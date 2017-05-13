module Scheduler
  class MinmaxShiftHelper

    def initialize(timeslot:, employee:, layout:, company:, options:)
      @timeslot = timeslot
      @employee = employee
      @layout = layout
      @company = company
      @options = options
    end

    def is_not_eligible
      exceeds_maximum = false
      fails_minumum = false
      if !company_preference.minimum_shift_length.nil?
        fails_minumum = false;
      end

      if !company_preference.maximum_shift_length.nil?
        exceeds_maximum = would_exceed_max
      end

      exceeds_maximum || fails_minumum
    end

    private

    attr_reader :timeslot
    attr_reader :employee
    attr_reader :layout
    attr_reader :company
    attr_reader :options

    def company_preference
      @_preference ||= PreferenceFinder.for(company)
    end

    def would_exceed_max
      # up direction
      assigned = true
      up_shift_length = 0
      next_up_timeslot = timeslot
      while assigned
        next_y = next_up_timeslot.y-1
        next_up_timeslot = layout.get_timeslot(timeslot.x, next_y)
        if next_up_timeslot && next_up_timeslot.has_employee?(employee.id)
          up_shift_length = up_shift_length + 1
        else
          assigned = false;
        end
      end

      # down direction
      assigned = true
      down_shift_length = 0
      next_down_timeslot = timeslot
      while assigned
        next_y = next_down_timeslot.y+1
        next_down_timeslot = layout.get_timeslot(timeslot.x, next_y)
        if next_down_timeslot && next_down_timeslot.has_employee?(employee.id)
          down_shift_length = down_shift_length + 1
        else
          assigned = false;
        end
      end

      sum_possible = up_shift_length + down_shift_length + 1
      sum_possible*options.time_interval_minutes > company_preference.maximum_shift_length
    end

  end
end
