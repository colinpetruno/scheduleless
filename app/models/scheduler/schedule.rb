module Scheduler
  class Schedule
    include ActiveModel::Model

    attr_reader :x_max
    attr_reader :y_max
    attr_accessor :company

    def initialize(company, employees, x_max, y_max)
      @layout = []

      @x_max = x_max
      @y_max = y_max
      @company = company

      @manager = ScheduleManager.new({:x_max => @y_max,
                                      :y_max => @x_max,
                                      :find_shift_alternative => false,
                                      :none_eligible_strategy => "IGNORE",
                                      :random_block_start_req => 20,
                                      :start_priority => 0 })
      @manager.schedule = self
      @manager.employees = employees
    end

    def self.for(company, employees)
      new(company, employees, 4, 4)
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
        column = []
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

    def generate_schedule
      @manager.prepare_initial_schedule
      @manager.auto_manage_schedule(50)

      # TODO: Turn into shifts
    end
  end
end