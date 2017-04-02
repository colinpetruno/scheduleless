module Scheduler
  class ScheduleManager
    DEFAULTS = {
      x_max: 7,
      y_max: 96,
      find_shift_alternative: false,
      none_eligible_strategy: "IGNORE",
      random_block_start_req: 20,
      start_priority: 0
    }

    def initialize(company:, options: {})
      @company = company

      # Note: Updated over time - redundant as player records are stored in timeslots
      #     Makes code access easier while making management harder
      #     TODO: Keep or destroy
      @options = DEFAULTS.merge(options)
    end

    def employees
      @company.users
    end

    def timeslots
      @_employee_timeslots ||= EmployeeTimeslots.new
    end

    def schedule=(schedule)
      @schedule = schedule
    end

    def print_scores
      employees.each do |player|
        puts "%{employees} : %{score} slots" % {employee: employee[:given_name], score: timeslots.count_for(employee)}
      end
    end

    def prepare_initial_schedule
      (0..@options[:x_max]).each do |x| # for each day of the week
        y = rand(@options[:y_max]) # choose a timeslot randomly

        slot = @schedule.timeslot(x, y) # get the timeslot

        if slot.not_full?
          # this is probably a bit odd?
          employee = employees[x % employees.length]
          slot.add_employee(employee)
          timeslots.add_for(employee: employee, day: x, slot_number: y)
        end
      end
    end

    def eligible_employees(slot)
      EligibilityFinder.for(slot, @schedule).find
    end

    def priority_employee(eligible_employees)
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

    def assign_timeslot(slot)
      elg_employees = eligible_employees(slot)

      if elg_employees.length > 0
        assigned_employee = priority_employee(elg_employees)
        slot.add_employee(assigned_employee)
        timeslots.add_for(employee: assigned_employee, day: slot.x, slot_number: slot.y)
      else
        # TODO handle Ignore or Random case
      end
    end

    def assign_iteration
      (0..@options[:x_max]).each do |x|
        (0..@options[:y_max]).each do |y|
          slot = @schedule.timeslot(x,y)
          if slot.not_full? then assign_timeslot(slot) end
        end
      end
    end

    def auto_manage_schedule(max_rounds)
      (0..max_rounds).each do
        assign_iteration
      end
    end
  end
end