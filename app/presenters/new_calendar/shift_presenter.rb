module NewCalendar
  class ShiftPresenter
    def initialize(shift:, manage: false, day_start: 0)
      @day_start = day_start
      @manage = manage
      @shift = shift
    end

    def classes
      array = ["shift", "length-#{shift_length.to_i}", "start-#{start_offset}"]
      array.push("edited") if shift.edited?

      array.reject(&:blank?).join(" ")
    end

    def time_range
      shift.time_range
    end

    def position
      shift.user.primary_position.name
    rescue
      ""
    end

    def user
      shift.user
    end

    private

    attr_reader :day_start, :manage, :shift

    def shift_length
      DateAndTime::ShiftDateTime.for(shift).length_in_minutes
    end

    def start_offset
      puts "DAY START IS #{day_start}"
      shift.minute_start - day_start
    end
  end
end
