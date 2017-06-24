module Scheduler
  class EligibilityFinder
    def initialize(layout:, timeslot:, location:, existing_shifts:, company:, options:)
      @layout = layout
      @timeslot = timeslot
      @location = location
      @existing_shifts = existing_shifts
      @company = company
      @options = options
    end

    # TODO Eligibility should only look for employees who COULD be schedule in this slot
    #   Removing all employees who could not (for varying reasons)
    # Vertical Adjacency does not belong here
    # Let the set of all employees be applicable in this situation
    def find(position)
      adjacent_employees.push(up_slot.position_employees[position]) if up_slot
      adjacent_employees.push(down_slot.position_employees[position]) if down_slot
      # adjacent_employees.push(right_slot.position_employees[position]) if right_slot
      # adjacent_employees.push(left_slot.position_employees[position]) if left_slot

      adjacent_employees.flatten!.uniq!
      adjacent_employees.compact!

      timeslot.employees.each do |employee|
        adjacent_employees.delete(employee)
      end

      adjacent_employees.each do |employee|
        # check if there is space for this employee

        # TODO
        # timeslot.position_available?(employee)

        # Would employee exceed any minmax shift preference
        if minmax_not_eligible(employee)
          adjacent_employees.delete(employee)
        end

        # check for existing schedules
        if @existing_shifts.user_scheduled_at(employee.id, timeslot.x, timeslot.y)
          adjacent_employees.delete(employee)
        end

        if @options.prevent_multi_location_schedule_daily
          if @existing_shifts.user_scheduled_during_day(employee.id, timeslot.x, @location.id)
            adjacent_employees.delete(employee)
          end
        end
      end

      remove_conflicts(adjacent_employees)
    end

    def employee_eligible_for?(employee, position_name)

      if !timeslot.position_room_available?(position_name)
        return false
      end

      if minmax_not_eligible(employee)
        return false
      end

      if @existing_shifts.user_scheduled_at(employee.id, timeslot.x, timeslot.y)
        return false
      end

      if @options.prevent_multi_location_schedule_daily
        if @existing_shifts.user_scheduled_during_day(employee.id, timeslot.x, @location.id)
          return false
        end
      end

      true
    end

    private

    attr_reader :layout, :timeslot, :existing_shifts, :company, :location, :options

    def get_timeslot(x, y)
      layout.get_timeslot(x, y)
    end

    def remove_conflicts (employees)
      employees.each do |employee|
        if existing_shifts.user_scheduled_at(employee.id, timeslot.x, timeslot.y)
          employees.delete(employee);
        end
      end

      employees
    end

    def adjacent_employees
      @_adjacent_employees ||= []
    end

    def up_slot
      get_timeslot(timeslot.x, timeslot.y - 1)
    end

    def down_slot
      get_timeslot(timeslot.x, timeslot.y + 1)
    end

    def right_slot
      get_timeslot(timeslot.x + 1, timeslot.y)
    end

    def left_slot
      get_timeslot(timeslot.x - 1, timeslot.y)
    end

    def minmax_not_eligible(employee)
      MinmaxShiftHelper.new(timeslot: timeslot, employee: employee, layout: layout, company: company, location: location, existing_shifts: existing_shifts, options: options).is_not_eligible
    end
  end
end
