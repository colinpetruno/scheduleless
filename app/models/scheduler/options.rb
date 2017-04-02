module Scheduler
  class Options
    DEFAULTS = {
      allow_zero_shifts: true,
      days_to_schedule: 7,
      time_interval_minutes: 15,
      find_shift_alternative: false,
      none_eligible_strategy: "IGNORE",
      random_block_start_req: 20,
      start_priority: 0,
      shift_range: 3 # what is this?
    }

    def initialize(start_date:, options: {})
      @options = DEFAULTS.merge(options)
      @start_date = start_date
    end

    def days_to_schedule
      options[:days_to_schedule]
    end

    def time_interval_minutes
      options[:time_interval_minutes]
    end

    def find_shift_alternative
      options[:find_shift_alternative]
    end

    def number_of_intervals
      (24*60) / options[:time_interval_minutes]
    end

    def start_date
      @start_date
    end

    def allow_zero_shift
      options[:allow_zero_shifts]
    end

    def shift_range
      options[:shift_range]
    end

    private

    attr_reader :options
  end
end
