require 'active_support/all'
module Scheduler
  class Schedule
    include ActiveModel::Model
    include ActiveSupport

    attr_accessor :company

    def self.for(company, schedule_start=Date.today, day_range=4, time_range=4)
      schedule = new(company, schedule_start, day_range, time_range)
      schedule
    end

    def initialize(company, schedule_start, day_range, time_range)
      # time_range needs looked into and removed / updated to interval minutes
      @options = Options.new(start_date: schedule_start, options: { days_to_schedule: day_range })
      @company = company

      @manager = ScheduleManager.
        new(company: company,
            options: {
              x_max: options.days_to_schedule,
              y_max: options.number_of_intervals
            })

      @manager.schedule = self
    end

    def manager
      @manager
    end

    def company
      @company
    end

    def location
      @company.locations.first
    end

    def layout
      @_layout ||= LayoutGenerator.for(self)
    end

    # what is x and what is y? perhaps some more descriptive variable names
    def timeslot(x=0,y=0)
      if x < 0 || x > options.days_to_schedule || y < 0 || y > options.number_of_intervals
        nil
      else
        layout.get_timeslot(x, y)
      end
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

    def generate_schedule
      @manager.prepare_initial_schedule
      @manager.auto_manage_schedule(50)
      generate_shifts
    end

    def shifts
      @shifts ||= generate_shifts
    end

    private

    attr_reader :options

    def generate_shifts
      ShiftGenerator.for(self, options).generate
    end
  end
end