class CalendarShowPresenter
  attr_reader :date, :current_location

  def initialize(user:, current_location: nil, date: Date.today)
    @date = date
    @current_location = current_location || Location.default_for(user)
    @user = user
  end

  def approvals?
    ScheduleApprovalPolicy::Scope.new(
      UserContext.new(location: current_location, user: user),
      SchedulingPeriod
    ).
    resolve.
    present?
  end

  def location_label(location)
    location.name || location.line_1
  end

  def location_list
    user.
      locations.
      where.
      not(id: current_location.id).
      order(:name, :line_1)
  end

  def next_shift
    @_next_shift ||= ShiftFinder.for(user).next.find
  end

  def next_shift_partial
    if next_shift.present?
      "next_shift"
    else
      "blank_next_shift"
    end
  end

  def next_shift_time
    # TODO: these shift methods could probably be in their own shift
    # presenter
    MinutesToTime.for(next_shift.minute_start)
  end

  def formatted_minutes_for(shift)
    "#{MinutesToTime.for(shift.minute_start)} - #{MinutesToTime.for(shift.minute_end)}"
  end

  def next_shift_date
    DateParser.new(date: next_shift.date).month_and_day
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
    @_location_schedule ||= LocationSchedule.
      new(location: current_location, date: date)
  end

  def shift_style(shift)
    # TODO: remove when using shared partial
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
