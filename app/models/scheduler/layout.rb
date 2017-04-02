module Scheduler
  class Layout
    def initialize
      # grid is array of arrays, the top level is the day, the second level
      # are the timeslots for that day
      @day_shift_grid = []
    end

    def get_timeslot(day, slot_number)
      @day_shift_grid[day][slot_number]
    end

    def add_day(day)
      @day_shift_grid.push(day)
    end
  end
end
