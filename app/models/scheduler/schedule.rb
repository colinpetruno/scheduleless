require 'active_support/all'
module Scheduler
  class Schedule
    include ActiveModel::Model
    include ActiveSupport

    attr_reader :x_max
    attr_reader :y_max
    attr_accessor :company

    def self.for(company, schedule_start=Date.today, day_range=4, time_range=4)
      schedule = new(company, schedule_start, day_range, time_range)
      schedule
    end

    def initialize(company, schedule_start, day_range, time_range)
      @schedule_start = schedule_start
      @x_max = day_range  # number of days to schedule for (default 7 = 1 week)
      @y_max = time_range # number of time units in a day (default 96 = 60min*24hr/15min)
      @company = company
      @location = company.locations.first

      @manager = ScheduleManager.
        new(company: company,
            options: {
              :x_max => @y_max,
              :y_max => @x_max
            })

      @manager.schedule = self
    end

    def layout
      @_layout ||= LayoutGenerator.for(self)
    end

    # what is x and what is y? perhaps some more descriptive variable names
    def timeslot(x=0,y=0)
      if x < 0 || x > @x_max || y < 0 || y > @y_max
        nil
      else
        layout.get_timeslot(x, y)
      end
    end

    def generate_shifts
      @shifts = []
      (0..@x_max).each do |x|
        running_shifts = {}
        (0..@y_max).each do |y|
          timeslot = timeslot(x,y);

          # Record all employees in this timeslot
          timeslot.employees.each do |employee|
            if running_shifts[employee.id].nil?
              running_shifts[employee.id] = {
                  "employee_id" => employee.id,
                  "day" => x,
                  "time_start" => y*15
              }
            end
          end

          # then for each employee in the running shift ..
          running_shifts.each do |id, shift|
            if !shift.nil?
              if !timeslot.has_employee?(id)
                # end this employees shift at the time y
                shift["time_end"] = y*15
                completed_shifts.push(shift)
                running_shifts[id] = nil
              end
            end

          end

        end

        # close out the remaining shifts
        running_shifts.each do |id, shift|
          if !shift.nil?
            shift["time_end"] = (@y_max+1) * 15
            completed_shifts.push(shift)
          end
        end
      end

      completed_shifts.each do |shift|
        day_advance = shift["day"].to_i
        date = @schedule_start + day_advance.days
        date_integer = date.strftime('%Y%m%d').to_i

        employee = @manager.employees.find(shift["employee_id"])
        user_location = @location.user_locations.find_by! user_id: employee.id

        @shifts.push(@company.shifts.build(user_location: user_location,
                               company: @company,
                               date: date_integer,
                               minute_start: shift["time_start"],
                               minute_end: shift["time_end"]))
      end
    end

    def print
      (0..@y_max).each do |y|
        (0..@x_max).each do |x|
          timeslot = @layout.get_timeslot(x, y)
          timeslot.print
        end
        printf "\n"
      end
    end

    def completed_shifts
      @_completed_shifts ||= []
    end

    def generate_schedule
      @manager.prepare_initial_schedule
      @manager.auto_manage_schedule(50)
      generate_shifts
    end

    def shifts
      @shifts
    end
  end
end