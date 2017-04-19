class CalendarShowPresenter
  def initialize(user:)
    @user = user
  end

  def next_shift
    ShiftFinder.for(user).next
  end

  def next_shift_partial
    if next_shift.present?
      "next_shift"
    else
      "blank_next_shift"
    end
  end

  def next_shift_time
    MinutesToTime.for(next_shift.minute_start)
  end

  def formatted_minutes_for(shift)
    "#{MinutesToTime.for(shift.minute_start)} - #{MinutesToTime.for(shift.minute_end)}"
  end

  def next_shift_date
    Date.parse(next_shift.date.to_s).strftime("%B %-d")
  end

  def next_shift_location
    next_shift.location
  end

  def next_shift_address_line
    next_shift_address.address
  end

  def next_shift_city_line
    next_shift_address.city_state_zip
  end

  def location_schedule
    @_location_schedule ||= LocationSchedule.for(user.locations.first)
  end

  def shift_style(shift)
    left = (shift.minute_start / 15) * 10
    width = (shift.minute_end - shift.minute_start) / 15 * 10

    "left: #{left}px; width: #{width}px"
  end

  private

  attr_reader :user

  def next_shift_address
    @_address ||= AddressFormatter.for(next_shift_location)
  end
end
