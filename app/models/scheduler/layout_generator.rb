module Scheduler
  class LayoutGenerator
    DEFAULTS = {
      days_to_schedule: 7,
      time_interval_minutes: 15,
      allow_zero_shift: true, # not sure what this is or why we need it
      shift_range: 3 # also unsure on this one
    }

    def self.for(schedule)
      new(schedule: schedule).generate
    end

    def initialize(schedule:, layout_class: Scheduler::Layout, options: {})
      @schedule = schedule
      @layout_class = layout_class
      @options = DEFAULTS.merge(options)
    end

    def generate
      (0..options[:days_to_schedule]).each do |day_number|
        day = []

        (0..number_of_intervals).each do |interval_number|
          day.push(Timeslot.new(day_number, interval_number, shift_allotment))
        end

        layout.add_day(day)
      end

      layout
    end

    private

    def shift_allotment
      if options[:allow_zero_shift]
        0 + rand(options[:shift_range] + 1)
      else
        1 + rand(options[:shift_range])
      end
    end

    def number_of_intervals
      (24*60) / options[:time_interval_minutes]
    end

    def layout
      @_layout ||= layout_class.new
    end

    attr_reader :options, :layout_class, :schedule
  end
end
