module Scheduler
  class ShiftGenerator
    def initialize(company:, location:, layout:, options:)
      @company = company
      @location = location
      @layout = layout
      @options = options
    end

    def generate
      (0..options.days_to_schedule).each do |x|
        running_shifts = {}

        (0..options.number_of_intervals).each do |y|
          timeslot = layout.get_timeslot(x,y);

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
            running_shifts[id] = nil
          end
        end
      end

      completed_shifts.each do |shift|
        day_advance = shift["day"].to_i
        date = options.start_date + day_advance.days
        date_integer = date.strftime('%Y%m%d').to_i

        # TODO: Avoid N+1 Query?
        employee = employees.find(shift["employee_id"])

        shifts.
          push(
            company.
            shifts.
            build(
              company: @company,
              date: date_integer,
              location: @location,
              minute_start: shift["time_start"],
              minute_end: shift["time_end"],
              user: employee
            ))
      end

      shifts
    end

    private

    attr_reader :company, :layout, :options

    def timeslot(x=0, y=0)
      layout.get_timeslot(x, y)
    end

    def employees
      company.users
    end

    def completed_shifts
      @_completed_shifts ||= []
    end

    def shifts
      @_shifts ||= []
    end
  end
end
