require 'active_support/all'
module Scheduler
  class Schedule
    include ActiveModel::Model
    include ActiveSupport

    attr_accessor :company

    def self.for(company, schedule_start=Date.today, day_range=4, time_range=4)
      schedule = new(company, schedule_start, day_range, time_range)
      schedule
    end

    def initialize(company, schedule_start, day_range, time_range)
      # time_range needs looked into and removed / updated to interval minutes
      @options = Options.new(start_date: schedule_start, options: { days_to_schedule: day_range })
      @company = company
    end

    def generate_schedule
      prepare_initial_schedule
      auto_manage_schedule(50)
      generate_shifts
    end

    # called from view
    def shifts
      @shifts ||= generate_shifts
    end

    private

    attr_reader :options

    def employees
      company.users
    end

    def generate_shifts
      ShiftGenerator.
        new(company: company, layout: layout, options: options).
        generate
    end

    def layout
      @_layout ||= LayoutGenerator.for(self, options)
    end

    def print
      (0..options.number_of_intervals).each do |y|
        (0..options.days_to_schedule).each do |x|
          timeslot = layout.get_timeslot(x, y)
          timeslot.print
        end
        printf "\n"
      end
    end

    def timeslots
      @_employee_timeslots ||= EmployeeTimeslots.new
    end

    def print_scores
      employees.each do |player|
        puts "%{employees} : %{score} slots" % {employee: employee[:given_name], score: timeslots.count_for(employee)}
      end
    end

    def prepare_initial_schedule
      (0..options.days_to_schedule).each do |x| # for each day of the week
        y = rand(options.number_of_intervals) # choose a timeslot randomly

        slot = layout.get_timeslot(x, y) # get the timeslot

        if slot.not_full?
          # this is probably a bit odd?
          employee = employees[x % employees.length]
          slot.add_employee(employee)
          timeslots.add_for(employee: employee, day: x, slot_number: y)
        end
      end
    end

    def eligible_employees(slot)
      EligibilityFinder.
        new(layout: layout, timeslot: slot, schedule: self).
        find
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
      (0..options.days_to_schedule).each do |x|
        (0..options.number_of_intervals).each do |y|
          slot = layout.get_timeslot(x,y)
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