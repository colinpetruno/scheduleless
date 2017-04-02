module Scheduler
  class LayoutGenerator
    def self.for(schedule, options)
      new(schedule: schedule, options: options).generate
    end

    def initialize(schedule:, layout_class: Scheduler::Layout, options: Options.new)
      @schedule = schedule
      @layout_class = layout_class
      @options = options
    end

    def generate
      (0..options.days_to_schedule).each do |day_number|
        day = []

        (0..options.number_of_intervals).each do |interval_number|
          day.push(Timeslot.new(day_number, interval_number, shift_allotment))
        end

        layout.add_day(day)
      end

      layout
    end

    private

    def shift_allotment
      if options.allow_zero_shift
        0 + rand(options.shift_range + 1)
      else
        1 + rand(options.shift_range)
      end
    end

    def layout
      @_layout ||= layout_class.new(options)
    end

    attr_reader :options, :layout_class, :schedule
  end
end
