module NewCalendar
  class LastShiftLocator
    def initialize(shifts:)
      @shifts = shifts
    end

    def find
      if overnight_shifts.present?
        overnight_shifts.max_by { |shift| shift.minute_end }
      else
        shifts.max_by { |shift| shift.minute_end }
      end
    end

    private

    attr_reader :shifts

    def locate_overnight_shifts
      shifts.find_all do |shift|
        shift.minute_start > shift.minute_end
      end
    end

    def overnight_shifts
      @_overnight_shifts ||= locate_overnight_shifts
    end
  end
end
