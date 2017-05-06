module Scheduler
  class EmployeeAssigner
    ROTATION_COUNT = 500 # number of assignment rounds to execute for

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
      auto_manage_schedule
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

      failed_assignments = 0
      num_timeslots = 0

      all_timeslots = []

      (0..options.days_to_schedule).each do |x|
        all_timeslots.push([])
        (0..options.number_of_intervals).each do |y|
          num_timeslots = num_timeslots + 1
          all_timeslots[x].push({x: x, y: y})
        end
      end

      all_timeslots.shuffle!

      all_timeslots.each do |day|
        day.shuffle!
      end

      all_timeslots.each do |day|
        day.each do |coordinate|
          slot = layout.get_timeslot(coordinate[:x], coordinate[:y])
          if slot.not_full?
            if !assign_timeslot(slot)
              failed_assignments = failed_assignments + 1
            end
          else
            failed_assignments = failed_assignments + 1
          end
        end
      end

      ## Did we make an assignment in this iteration
      failed_assignments != num_timeslots
      false
    end

    def auto_manage_schedule() # looks good
      successful_iteration = assign_iteration

      # if the iteration is successful, run another round
      if successful_iteration
        auto_manage_schedule()
      else
        # if the iteration fails attempt an injection if necessary or cancel
        if !layout.all_slots_full?
          if perform_employee_injection
            auto_manage_schedule()
          end
        end
      end
    end

    def perform_employee_injection
      # find all unfilled positions
      unfilled_timeslots = []
      (0..options.days_to_schedule).each do |x|
        (0..options.number_of_intervals).each do |y|
          slot = layout.get_timeslot(x,y)
          unfilled_timeslots.push(slot) if slot.not_full?
        end
      end

      # shuffle the unfilled timeslots
      unfilled_timeslots.shuffle!

      # find a timeslot we can inject an employee and perform the injection
      #   Then leave the injection
      unfilled_timeslots.each do |slot|
        # list employees sorted by priority
        sorted_employees = sort_employees_by_timeslots

        sorted_employees.each do |employee|

          if !slot.has_employee?(employee.id) and !minmax_not_eligible(slot, employee)
            employee.positions.each do |position|
              if slot.position_room_available?(position.name)
                slot.add_employee(employee, position.name)
                return true;
              end
            end

          end
        end

      end

      false
    end

    def sort_employees_by_timeslots
      employees.sort_by do |employee|
        timeslots.count_for(employee)
      end
    end

    def prepare_initial_schedule # looks good
      (0..options.days_to_schedule).each do |x|
        y = rand(options.number_of_intervals)
        # this is probably a bit odd?
        employee = employees[x % employees.length]
        position = employee.positions.sample

        not_scheduled = true
        iterations = 0

        # iterate through a day and attempt to schedule
        while not_scheduled
          slot = layout.get_timeslot(x, y)
          # TODO: user has no positions breaks this
          if not existing_shifts.user_scheduled_at(employee.id, x, y) and slot.not_full? and slot.position_room_available?(position.name)
            slot.add_employee(employee, position.name)
            timeslots.add_for(employee: employee, day: x, slot_number: y)
            not_scheduled = false
          end
          iterations = iterations + 1
          position = employee.positions.sample
          if iterations > options.number_of_intervals
            not_scheduled = false
          end
          y = (y+1) % options.number_of_intervals

        end
      end
    end

    def assign_timeslot(slot) # looks okay

      assigned = false

      slot.positions.each do |position|
        elg_employees = eligible_employees(slot, position)

        if elg_employees.length > 0 and slot.position_room_available?(position)
          assigned_employee = priority_employee(elg_employees)
          slot.add_employee(assigned_employee, position)
          timeslots.add_for(employee: assigned_employee, day: slot.x, slot_number: slot.y)
          assigned = true
        end
      end

      assigned
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

    def eligible_employees(slot, position)
      EligibilityFinder.
        new(layout: layout, timeslot: slot, existing_shifts: existing_shifts, company: company, options: options).
        find(position)
    end

    def minmax_not_eligible(timeslot, employee)
      MinmaxShiftHelper.new(timeslot: timeslot, employee: employee, layout: layout, company: company, options: options).is_not_eligible
    end
  end
end
