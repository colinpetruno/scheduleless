class AvailabilityChecker
  # This ensures that user is under the daily and weekly maximum as determined
  # by the company and them

  def initialize(date:, minutes_to_add:, user:)
    @date = date.is_a?(Integer) ? Date.parse(date.to_s) : date
    @minutes_to_add = minutes_to_add
    @user = user
  end

  def can_work?
    # TODO: Find a better name for this method
    available? && time_available?
  end

  private

  attr_reader :date, :minutes_to_add, :user

  def available?
    # TODO: this will check time off requests
    true
  end

  def beginning_of_week
    # TODO: Ensure this day matches company settings
    date.beginning_of_week(:monday).strftime("%Y%m%d").to_i
  end

  def end_of_week
    # TODO: Ensure this day matches company settings
    date.end_of_week(:monday).strftime("%Y%m%d").to_i
  end

  def max_daily
    # TODO: Get this smartly from settings / user info
    480
  end

  def max_weekly
    # TODO: Get this smartly / user info
    2400
  end

  def scheduled_time_this_week
    # TODO: this could break hard if shifts are overnight
    # maybe fix it in the shift model and do
    # shifts_this_week.map(&:length_in_minutes).sum
    start_times = shifts_this_week.sum(:minute_start)
    end_times = shifts_this_week.sum(:minute_end)

    end_times - start_times
  end

  def scheduled_time_today
    # TODO: See above comment
    start_times = shifts_today.sum(:minute_start)
    end_times = shifts_today.sum(:minute_end)

    end_times - start_times
  end

  def shifts_this_week
    Shift.where(date: beginning_of_week..end_of_week, user_id: user.id)
  end

  def shifts_today
    Shift.where(date: date.strftime("%Y%m%d").to_i, user_id: user.id)
  end

  def time_available?
    work_more_today? && work_more_this_week?
  end

  def work_more_this_week?
    (scheduled_time_this_week + minutes_to_add) <= max_weekly
  end

  def work_more_today?
    (scheduled_time_today + minutes_to_add) <= max_daily
  end
end
