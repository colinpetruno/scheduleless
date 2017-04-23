module Scheduler
  class LayoutGenerator
    def self.for(schedule, rules, options)
      new(schedule: schedule, rules: rules, options: options).generate
    end

    def initialize(schedule:, layout_class: Scheduler::Layout, rules:, options: Options.new)
      @schedule = schedule
      @layout_class = layout_class
      @options = options
      @rules = rules
    end

    def generate
      (0..options.days_to_schedule).each do |day_number|
        day = []

        (0..options.number_of_intervals).each do |interval_number|
          day.push(Timeslot.new(day_number, interval_number, shift_allotment(interval_number), rules, options))
        end

        layout.add_day(day)
      end

      layout
    end

    private

    def shift_allotment(interval_number)
      allocation = 0
      rules.each do |rule|
        allocation = allocation + rule.number_of_employees if rule_within_bounds(rule.period, interval_number)
      end
      allocation
    end

    def rule_within_bounds(rule_period, interval)
      interval_minutes = interval*options.time_interval_minutes
      rule_timeframe = options.period_timeframes(rule_period)
      interval_minutes >= rule_timeframe[:start] && interval_minutes < rule_timeframe[:end]
    end

    def layout
      @_layout ||= layout_class.new(options)
    end

    attr_reader :options, :layout_class, :schedule, :rules
  end
end
