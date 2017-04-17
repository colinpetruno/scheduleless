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

  private

  attr_reader :user

  def next_shift_address
    @_address ||= AddressFormatter.for(next_shift_location)
  end
end
