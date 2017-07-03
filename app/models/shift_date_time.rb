class ShiftDateTime
  # TODO Test meeee
  def self.for(shift)
    new(shift: shift)
  end

  def initialize(shift:)
    @shift = shift
  end

  def end
    Time.
      find_zone(timezone).
      parse(end_time_string)
  end

  def start
    Time.
      find_zone(timezone).
      parse(start_time_string)
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
    shift.location
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
