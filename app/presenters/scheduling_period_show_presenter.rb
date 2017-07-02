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

  def partial
    if view == "day"
      "calendars/day_schedule"
      "locations/scheduling_periods/daily_view"
    else
      "calendars/week_schedule"
    end
  end

  def partial_options
    if view == "day"
      { presenter: DaySchedulePreviewPresenter.new(scheduling_period, date) }
    else
      { presenter: WeekSchedulePreviewPresenter.new(scheduling_period, date) }
    end
  end
end
