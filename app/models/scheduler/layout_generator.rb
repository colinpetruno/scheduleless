module Scheduler
  class LayoutGenerator
    def self.for(location, rules, options)
      new(location: location, rules: rules, options: options).generate
    end

    def initialize(location:, layout_class: Scheduler::Layout, rules:, options: Options.new)
      @location = location
      @layout_class = layout_class
      @options = options
      @rules = rules
    end

    def generate
      (0..options.days_to_schedule).each do |day_number|
        day = []

        (0..options.number_of_intervals).each do |interval_number|
          day.push(Timeslot.new(day_number, interval_number))
        end

        layout.add_day(day)
      end

      apply_schedule_rules
      layout
    end

    private

    def apply_schedule_rules
      rules.each do |rule|
        if !rule_parser.method(rule[:period]).nil?
          method_object = rule_parser.method(rule[:period])
          method_object.call(rule)
        else
          puts "Unhandled Period Timeframe Found", rule[:period]
        end
      end
    end

    def rule_parser
      @_rule_parser ||= ScheduleRuleParser.new(layout: layout, location: location, options: options)
    end

    def layout
      @_layout ||= layout_class.new(options)
    end

    attr_reader :options, :layout_class, :rules, :location
  end
end
