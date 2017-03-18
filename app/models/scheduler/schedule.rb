module Scheduler
  class Schedule

    attr_reader :x_max
    attr_reader :y_max

    def initialize(x_max, y_max)
      @layout = []
      @x_max = x_max
      @y_max = y_max
    end

    # what is x and what is y? perhaps some more descriptive variable names
    def timeslot(x=0,y=0)
      if x < 0 || x > @x_max || y < 0 || y > @y_max
        nil
      else
        @layout[x][y]
      end
    end

    def generate_schedule_layout(allow_zero_shift, shift_range)
      (0..@x_max).each do |x|
        column = [];
        (0..@y_max).each do |y|

          if allow_zero_shift
            shift_allotment = 0 + rand(shift_range + 1)
          else
            shift_allotment = 1 + rand(shift_range)
          end

          column.push(Timeslot.new(x, y, shift_allotment))
        end
        @layout.push(column)
      end
    end

    def print
      (0..@y_max).each do |y|
        (0..@x_max).each do |x|
          timeslot = @layout[x][y]
          timeslot.print
        end
        printf "\n"
      end
    end
  end
end