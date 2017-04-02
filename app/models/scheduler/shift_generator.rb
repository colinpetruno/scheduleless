module Scheduler
  class ShiftGenerator
    def self.for(schedule, options)
      new(schedule: schedule, options: options)
    end

    def initialize(schedule:, options:)
      @schedule = schedule
      @options = options
    end

    def generate
      (0..options.days_to_schedule).each do |x|
        running_shifts = {}

        (0..options.number_of_intervals).each do |y|
          timeslot = schedule.timeslot(x,y);

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
            shift["time_end"] = (options.number_of_intervals+1) * 15
            completed_shifts.push(shift)
          end
        end
      end

      completed_shifts.each do |shift|
        day_advance = shift["day"].to_i
        date = options.start_date + day_advance.days
        date_integer = date.strftime('%Y%m%d').to_i

        employee = schedule.manager.employees.find(shift["employee_id"])
        user_location = schedule.location.user_locations.find_by! user_id: employee.id

        shifts.push(schedule.company.shifts.build(user_location: user_location,
                               company: @company,
                               date: date_integer,
                               minute_start: shift["time_start"],
                               minute_end: shift["time_end"]))
      end

      shifts
    end

    private

    attr_reader :options, :schedule

    def completed_shifts
      @_completed_shifts ||= []
    end

    def shifts
      @_shifts ||= []
    end
  end
end
