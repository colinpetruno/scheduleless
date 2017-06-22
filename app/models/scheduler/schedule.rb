module Scheduler
  class Schedule
    def self.for(scheduling_period)
      new(scheduling_period: scheduling_period)
    end

    def initialize(scheduling_period:)
      @scheduling_period = scheduling_period
    end

    def company
      # TODO: Does this need to be public?
      scheduling_period.company
    end

    def generate
      return if scheduling_period.location.users.blank?

      employee_assigner.assign
      generate_shifts
    end

    def location
      # TODO: Does this need to be public?
      scheduling_period.location
    end

    def shifts
      # called from view, TODO: This should not be needed soon
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

    attr_reader :scheduling_period

    def date_end
      Date.parse(scheduling_period.end_date.to_s)
    end

    def date_start
      Date.parse(scheduling_period.start_date.to_s)
    end

    def days_to_schedule
      (date_end - date_start).to_i
    end

    def employee_assigner
      @_employee_assigner ||= EmployeeAssigner.
        new(company: company, location: location, layout: layout,
            date_start: date_start, options: options)
    end

    def employees
      location.users
    end

    def generate_shifts
      # don't want to schedule for users, we should surface this error handling
      # better
      return false if location.users.blank?

      ShiftGenerator.
        new(
          layout: layout,
          options: options,
          scheduling_period: scheduling_period).
        generate
    end

    def layout
      @_layout ||= LayoutGenerator.for(self, schedule_rules, options)
    end

    def options
      @_options ||= Options.
        new(start_date: date_start,
            options: { days_to_schedule: days_to_schedule })
    end

    def schedule_rules
      if location.schedule_rules.length > 0 and location.use_custom_scheduling_rules
        @_schedule_rules ||= location.schedule_rules
      else
        @_schedule_rules ||= company.schedule_rules
      end
    end
  end
end
