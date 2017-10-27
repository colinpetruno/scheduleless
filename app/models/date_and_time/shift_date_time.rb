module DateAndTime
  class ShiftDateTime
    include ActionView::Helpers::NumberHelper
    # TODO Test meeee
    def self.for(shift, location=nil)
      new(shift: shift, location: location)
    end

    def initialize(shift:, location: nil)
      @location = location
      @shift = shift
    end

    def day
      Date.parse(shift.date.to_s).day
    end

    def end
      Time.
        find_zone(timezone).
        parse(end_time_string)
    end

    def length_in_hours
      length_in_minutes.to_f / 60.to_f
    end

    def length_in_minutes
      # difference is in seconds
      (self.end - self.start).to_f / 60.to_f
    end

    def month
      month_number = Date.parse(shift.date.to_s).month
      I18n.t("date.month_names")[month_number]
    end

    def start
      Time.
        find_zone(timezone).
        parse(start_time_string)
    end

    def time_range
      "#{MinutesToTime.for(shift.minute_start)} - #{MinutesToTime.for(shift.minute_end)}".gsub(":00", "")
    end

    def timezone
      location.time_zone
    end

    private

    attr_accessor :shift

    def end_time_string
      if overnight?
        "#{tomorrows_date} #{shift.minute_end / 60}:#{shift.minute_end % 60}"
      else
        "#{shift.date} #{shift.minute_end / 60}:#{shift.minute_end % 60}"
      end
    end

    def location
      @location ||= shift.location
    end

    def overnight?
      shift.minute_end < shift.minute_start
    end

    def start_time_string
      "#{shift.date} #{shift.minute_start / 60}:#{shift.minute_start % 60}"
    end

    def tomorrows_date
      (Date.parse(shift.date.to_s) + 1.day).to_s(:integer)
    end
  end
end
