module Scheduler
  class EmployeeAssigner
    ROTATION_COUNT = 50 # number of assignment rounds to execute for

    def initialize(company:, location:, layout:, date_start:, options: Options.new)
      @company = company
      @location = location
      @layout = layout
      @date_start = date_start;
      @options = options

      existing_shifts
    end

    def assign
      prepare_initial_schedule
      auto_manage_schedule(ROTATION_COUNT)
    end

    private

    attr_reader :company, :location, :layout, :date_start, :options

    def timeslots
      @_employee_timeslots ||= EmployeeTimeslots.new
    end

    def employees
      location.users
    end

    def existing_shifts
      @_existing_shifts ||= ExistingShifts.new(company, date_start)
    end

    def assign_iteration # looks good
      (0..options.days_to_schedule).each do |x|
        (0..options.number_of_intervals).each do |y|
          slot = layout.get_timeslot(x,y)
          if slot.not_full? then assign_timeslot(slot) end
        end
      end
    end

    def auto_manage_schedule(max_rounds) # looks good
      (0..max_rounds).each do
        assign_iteration
      end
    end

    def prepare_initial_schedule # looks good
      (0..options.days_to_schedule).each do |x|
        y = rand(options.number_of_intervals)

        slot = layout.get_timeslot(x, y)

        if slot.not_full?
          # this is probably a bit odd?
          employee = employees[x % employees.length]

          if not existing_shifts.user_scheduled_at(employee.id, x, y)
            slot.add_employee(employee)
            timeslots.add_for(employee: employee, day: x, slot_number: y)
          end
        end
      end
    end

    def assign_timeslot(slot) # looks okay
      elg_employees = eligible_employees(slot)

      if elg_employees.length > 0
        assigned_employee = priority_employee(elg_employees)
        slot.add_employee(assigned_employee)
        timeslots.add_for(employee: assigned_employee, day: slot.x, slot_number: slot.y)
      else
        # TODO handle Ignore or Random case
      end
    end

    def priority_employee(eligible_employees) # looks good
      lowest_score = Float::INFINITY
      lowest_employee = nil;

      eligible_employees.each do |employee|
        if timeslots.count_for(employee) < lowest_score
          lowest_employee = employee
          lowest_score = timeslots.count_for(employee)
        end
      end

      lowest_employee
    end

    def eligible_employees(slot)
      EligibilityFinder.
        new(layout: layout, timeslot: slot, existing_shifts: existing_shifts).
        find
    end
  end
end
