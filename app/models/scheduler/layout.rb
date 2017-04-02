module Scheduler
  class Layout
    def initialize(options)
      # grid is array of arrays, the top level is the day, the second level
      # are the timeslots for that day
      @day_shift_grid = []
      @options = options
    end

    def get_timeslot(day, slot_number)
      if not_inside_the_grid?(day, slot_number)
        nil
      else
        @day_shift_grid[day][slot_number]
      end
    end

    def add_day(day)
      @day_shift_grid.push(day)
    end

    private

    attr_reader :options

    def not_inside_the_grid?(day, slot_number)
      (0..options.days_to_schedule).exclude?(day) || (0..options.number_of_intervals).exclude?(slot_number)
    end
  end
end
