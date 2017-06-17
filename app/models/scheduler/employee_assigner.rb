module Scheduler
  class EmployeeAssigner
    ROTATION_COUNT = 50  # number of assignment rounds to execute for
                         # if we meet the rotation account, then 100% shift coverage is not met

    SCHEDULE_STRATEGY = "grow"

    def initialize(company:, location:, layout:, date_start:, options: Options.new)
      @company = company
      @location = location
      @layout = layout
      @date_start = date_start
      @options = options

      existing_shifts
    end

    def assign
      prepare_initial_schedule
      auto_manage_schedule
    end

    private

    attr_reader :company, :location, :layout, :date_start, :options

    def employees
      location.users.select{|u| u.positions.length > 0}
    end

    def timeslots
      @_employee_timeslots ||= EmployeeTimeslots.new
    end

    def existing_shifts
      @_existing_shifts ||= ExistingShifts.new(company, date_start, options)
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

      if SCHEDULE_STRATEGY == "random"
        all_timeslots.shuffle!

        all_timeslots.each do |day|
          day.shuffle!
        end
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

    def auto_manage_schedule(failures=0) # looks good
      if failures > ROTATION_COUNT
        return true
      end
      successful_iteration = assign_iteration

      # if the iteration is successful, run another round
      if successful_iteration
        auto_manage_schedule(0)
      else
        # if the iteration fails attempt an injection if necessary or cancel
        if !layout.all_slots_full?
          if perform_employee_injection
            auto_manage_schedule(0)
          else
            auto_manage_schedule(failures+1)
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
          employee.positions.each do |position|
            if can_schedule?(slot, employee, position, location)
              successful_injection = assign_employee_timeslot(employee, position.name, slot)
              if not successful_injection
                return false
              end
              return true;
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
        y = 0 #rand(options.number_of_intervals)
        # this is probably a bit odd?

        # check to ensure there are employees availalbe or line 153 gives
        # a divide by zero error
        if employees.length == 0
          next
        end

        employee = employees[x % employees.length]
        position = employee.positions.sample

        not_scheduled = true
        iterations = 0

        # iterate through a day and attempt to schedule
        while not_scheduled
          slot = layout.get_timeslot(x, y)
          # TODO: user has no positions breaks this
          if can_schedule?(slot, employee, position, location)
            assign_employee_timeslot(employee, position.name, slot)
            not_scheduled = false
          else
            if Rails.env.development?
              Rails.logger.info("Cannot schedule #{employee.id}")
              debug_can_schedule?(slot, employee, position, location)
            end
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
          assigned_employee = priority_employee(elg_employees, slot, position)
          assign_employee_timeslot(assigned_employee, position, slot)
          assigned = true
        end
      end

      assigned
    end

    def assign_employee_timeslot(employee, position_name, slot)
      # check if a min shift length is required
      preferences = PreferenceFinder.for(location)
      min_shift_length = preferences.minimum_shift_length

      if min_shift_length

        # run min shift counter
        #   Add user up Y positions until = 0 then use remainder to schedule down
        y_up_shift_height = count_min_shift_height(employee, position_name, slot, -1, 0)
        y_down_shift_height = count_min_shift_height(employee, position_name, slot, 1, 0)

        # if the total shift heigh up and down is greater than the minimum required - start scheduling
        if (y_up_shift_height + y_down_shift_height)*options.time_interval_minutes > min_shift_length

          # start by scheduling upwards
          y_up_traveled = schedule_for_height(employee, position_name, slot, -1, [y_up_shift_height, min_shift_length/options.time_interval_minutes].min, 0)

          # if scheduling upwards is less than the minimum, start scheduling down until min shift is met
          if y_up_traveled < min_shift_length/options.time_interval_minutes
            schedule_for_height(employee, position_name, slot, 1, [y_down_shift_height-y_up_traveled, min_shift_length/options.time_interval_minutes].min, 0)
          end

          true
        end

        false
      else
        # otherwise just assign
        slot.add_employee(employee, position_name)
        timeslots.add_for(employee: employee, day: slot.x, slot_number: slot.y)

        true
      end
    end

    def schedule_for_height(employee, position_name, slot, direction, allotment_remaining, height_traveled)
      # if we out of height or upon scheduling would violate minimax restrictions - return
      if allotment_remaining <= 0 or slot.nil? or minmax_not_eligible(slot, employee)
        return height_traveled
      end

      # If the employee can be scheduled then do so
      if !slot.has_employee?(employee.id)
        slot.add_employee(employee, position_name)
        timeslots.add_for(employee: employee, day: slot.x, slot_number: slot.y)
      end

      schedule_for_height(employee, position_name, layout.get_timeslot(slot.x, slot.y+direction), direction, allotment_remaining-1, height_traveled+1)
    end

    # Returns the height from a position that can be traveled until an ineligibility occurs
    def count_min_shift_height(employee, position, slot, direction, n)

      # Return if not eligible and not assigned (or doesnt exist)
      if (!employee_eligible_for?(slot, employee, position) and !slot.has_employee?(employee.id)) or slot.nil?
        return n
      end

      count_min_shift_height(employee, position, layout.get_timeslot(slot.x, slot.y+direction), direction, n+1)
    end

    def priority_employee(eligible_employees, slot, position) # looks good
      priority_finder(eligible_employees, slot, position)
    end

    def debug_can_schedule?(slot, employee, position, location)
      Rails.logger.info("DEBUGGING FOR user_id: #{employee.id}, position_id: #{position.id}, location_id: #{location.id}")
      Rails.logger.info("user_scheduled_at is #{!existing_shifts.user_scheduled_at(employee.id, slot.x, slot.y)}")
      Rails.logger.info("user_scheduled_during_day is #{!existing_shifts.user_scheduled_during_day(employee.id, slot.x, location.id)}")
      Rails.logger.info("user_scheduled_at is #{!existing_shifts.user_scheduled_at(employee.id, slot.x, slot.y)}")
      Rails.logger.info("slot.not_full? is #{slot.not_full?}")
      Rails.logger.info("slot.position_room_available? is #{slot.position_room_available?(position.name)}")
      Rails.logger.info("minmax_not_eligible is #{!minmax_not_eligible(slot, employee)}")
      Rails.logger.info("")
      Rails.logger.info("")
    end

    # Check all parameters on a slot w/r/t an employee to determine eligibility to assign
    def can_schedule?(slot, employee, position, location)
      !existing_shifts.user_scheduled_at(employee.id, slot.x, slot.y) &&
        !existing_shifts.user_scheduled_during_day(employee.id, slot.x, location.id) &&
        !existing_shifts.user_scheduled_at(employee.id, slot.x, slot.y) &&
        slot.not_full? &&
        slot.position_room_available?(position.name) &&
        !minmax_not_eligible(slot, employee)
    end

    def eligible_employees(slot, position)
      EligibilityFinder.
        new(layout: layout, timeslot: slot, location: location, existing_shifts: existing_shifts, company: company, options: options).
        find(position)
    end

    def employee_eligible_for?(slot, employee, position)
      EligibilityFinder.
        new(layout: layout, timeslot: slot, location: location, existing_shifts: existing_shifts, company: company, options: options).
        employee_eligible_for?(employee, position)
    end

    def priority_finder(eligible_employees, slot, position)
      PriorityFinder.new(options: options).highest_priority_employee(eligible_employees, position, slot, layout)
    end

    def minmax_not_eligible(timeslot, employee)
      MinmaxShiftHelper.new(timeslot: timeslot, employee: employee, layout: layout, company: company, existing_shifts: existing_shifts, options: options).is_not_eligible
    end
  end
end
