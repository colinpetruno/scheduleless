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
      @employee_timeslots = {} # predetermined inputs?
      @options = DEFAULTS.merge(options)
    end

    def employees
      @company.users
    end

    def schedule=(schedule)
      @schedule = schedule
    end

    def print_scores
      @employees.each do |player|
        puts "%{employees} : %{score} slots" % {employee: employee[:given_name], score: @employee_timeslots[employee].length}
      end
    end

    def prepare_initial_schedule
      @employees.each do |employee|
        @employee_timeslots[employee] = []
      end

      (0..@options[:x_max]).each do |x|
        y = rand(@options[:y_max])
        slot = @schedule.timeslot(x, y)

        fails = 0
        fails_limit = 5

        while slot.full && fails < fails_limit
          y = rand(@options[:y_max])
          slot = @schedule.timeslot(x, y)
          fails = fails + 1
        end

        if !slot.full
          employee = @employees[x % @employees.length]
          puts employee
          slot.add_employee(employee)
          @employee_timeslots[employee].push([x, y])
        end
      end
    end

    def eligible_employees(slot)
      # TODO: what about making slot a class? the class can have references to
      # the surrounding classes. slot.up, slot.left, slot.right
      up_slot = @schedule.timeslot(slot.x, slot.y - 1)
      right_slot = @schedule.timeslot(slot.x + 1, slot.y)
      down_slot = @schedule.timeslot(slot.x, slot.y + 1)
      left_slot = @schedule.timeslot(slot.x - 1, slot.y)

      # TODO: Can Adjacent Players be a class as well?
      adjacent_employees = []
      adjacent_employees.push(up_slot.employees) if up_slot
      adjacent_employees.push(right_slot.employees) if right_slot
      adjacent_employees.push(down_slot.employees) if down_slot
      adjacent_employees.push(left_slot.employees) if left_slot

      adjacent_employees.flatten!.uniq!

      slot.employees.each do |employee|
        adjacent_employees.delete(employee)
      end

      adjacent_employees
    end

    def priority_employee(eligible_employees)
      lowest_score = Float::INFINITY
      lowest_employee = nil;

      eligible_employees.each do |employee|
        if @employee_timeslots[employee].length < lowest_score
          lowest_employee = employee
          lowest_score = @employee_timeslots[employee].length
        end
      end

      lowest_employee
    end

    def assign_timeslot(slot)
      elg_employees = eligible_employees(slot)
      if elg_employees.length > 0
        assigned_employee = priority_employee(elg_employees)
        slot.add_employee(assigned_employee)
        @employee_timeslots[assigned_employee].push([slot.x, slot.y])

      else
        # TODO handle Ignore or Random case
      end
    end

    def assign_iteration
      (0..@options[:x_max]).each do |x|
        (0..@options[:y_max]).each do |y|
          slot = @schedule.timeslot(x,y)
          if !slot.full then assign_timeslot(slot) end
        end
      end
    end

    def auto_manage_schedule(max_rounds)
      @round = 0
      (0..max_rounds).each do
        assign_iteration
        @round = @round + 1
      end
    end

    def generate
      self.prepare_initial_schedule
      self.auto_manage_schedule(50)
    end
  end
end