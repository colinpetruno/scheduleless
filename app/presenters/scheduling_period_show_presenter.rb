class SchedulingPeriodShowPresenter
  attr_reader :date, :scheduling_period, :view

  def initialize(scheduling_period, date = nil, view="day")
    @date = date
    @scheduling_period = scheduling_period
    @view = view
  end

  def location
    scheduling_period.location
  end

  def day_to_open
    date || day_keys.first
  end

  def shifts
    scheduling_period.in_progress_shifts.includes(:user)
  end

  def shifts_for(day)
    shifts_by_day_hash[day.to_i]
  end

  def day_keys
    (start_date..end_date).map { |date| date.to_s(:integer).to_i }
  end

  def partial
    if view == "day"
      "locations/scheduling_periods/daily_view"
    else
      "calendars/week_schedule"
    end
  end

  def partial_options
    if view == "day"
      { presenter: self }
    else
      { presenter: WeekSchedulePreviewPresenter.new(scheduling_period, date) }
    end
  end

  private


  def build_shift_hash
    day_keys.inject({}) do |object, day|
      object[day] = shifts.select { |shift| shift.date == day }
      object
    end
  end

  def end_date
    Date.parse(scheduling_period.end_date.to_s)
  end

  def shifts_by_day_hash
    @_shifts_by_day_hash ||= build_shift_hash
  end

  def start_date
    Date.parse(scheduling_period.start_date.to_s)
  end
end
