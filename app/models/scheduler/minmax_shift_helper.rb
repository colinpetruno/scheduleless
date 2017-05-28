module Scheduler
  class MinmaxShiftHelper

    MAX_SHIFT_STRATEGY = 'ABSOLUTE' # ABSOLUTE: Cannot exceed maximum in any day period TODO: Make this another parameter varying on any timeframe
                                    # DISJOINTED: Cannot exceed maximum in consecutive time period

    def initialize(timeslot:, employee:, layout:, company:, existing_shifts:, options:)
      @timeslot = timeslot
      @employee = employee
      @layout = layout
      @company = company
      @existing_shifts = existing_shifts
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
      if MAX_SHIFT_STRATEGY == 'DISJOINTED'
        exceeds_max_shift_disjointed
      elsif MAX_SHIFT_STRATEGY == 'ABSOLUTE'
        exceeds_max_shift_absolute
      end

    end

    def exceeds_max_shift_absolute
      # Count the number of timeslots the employee has today already
      day = timeslot.y
      time = 0
      slot = layout.get_timeslot(day, time)
      num_assigned = 0

      while not slot.nil?
        num_assigned = num_assigned + 1 if slot.has_employee?(employee.id)
        time = time + 1
        slot = layout.get_timeslot(day, time)
      end

      total_time_scheduled = num_assigned * options.time_interval_minutes
      total_time_scheduled > max_shift_length
    end

    def exceeds_max_shift_disjointed
      # up direction
      assigned = true
      up_shift_length = 0
      next_up_timeslot = timeslot
      while assigned
        next_y = next_up_timeslot.y-1
        next_up_timeslot = layout.get_timeslot(timeslot.x, next_y)
        if next_up_timeslot and next_up_timeslot.has_employee?(employee.id)
          up_shift_length = up_shift_length + 1
        else
          if @existing_shifts.user_scheduled_at(employee.id, timeslot.x, next_y)
            up_shift_length = up_shift_length + 1
          else
            assigned = false;
          end
        end
      end

      # down direction
      assigned = true
      down_shift_length = 0
      next_down_timeslot = timeslot
      while assigned
        next_y = next_down_timeslot.y+1
        next_down_timeslot = layout.get_timeslot(timeslot.x, next_y)
        if next_down_timeslot and next_down_timeslot.has_employee?(employee.id)
          down_shift_length = down_shift_length + 1
        else
          if @existing_shifts.user_scheduled_at(employee.id, timeslot.x, next_y)
            down_shift_length = down_shift_length + 1
          else
            assigned = false;
          end
        end
      end

      sum_possible = up_shift_length + down_shift_length + 1
      sum_possible*options.time_interval_minutes > max_shift_length
    end

    def max_shift_length
      max = company_preference.maximum_shift_length
      if max and company_preference.break_length
        max = max + company_preference.break_length
      end

      max
    end

  end
end
