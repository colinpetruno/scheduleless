require 'active_support/all'
module Scheduler
  class Schedule
    include ActiveModel::Model
    include ActiveSupport

    attr_accessor :company
    attr_accessor :location

    def self.for(company, location={}, schedule_start=Date.today, day_range=4, time_range=4)
      schedule = new(company, location, schedule_start, day_range, time_range)
      schedule
    end

    def initialize(company, location, schedule_start, day_range, time_range)
      # time_range needs looked into and removed / updated to interval minutes
      @options = Options.new(start_date: schedule_start, options: { days_to_schedule: day_range })
      @company = company
      @location = location
      @schedule_start = schedule_start
    end

    def generate
      employee_assigner.assign
      generate_shifts
      print
    end

    # called from view
    def shifts
      @shifts ||= generate_shifts
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

    private

    attr_reader :options

    def employee_assigner
      @_employee_assigner ||= EmployeeAssigner.
        new(company: company, location: location, layout: layout,  date_start: @schedule_start, options: options)
    end

    def employees
      company.users
    end

    def generate_shifts
      ShiftGenerator.
        new(company: company, location: location, layout: layout, options: options).
        generate
    end

    def schedule_rules
      @_schedule_rules ||= company.schedule_rules
    end

    def layout
      @_layout ||= LayoutGenerator.for(self, schedule_rules, options)
    end
  end
end