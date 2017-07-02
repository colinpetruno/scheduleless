class DaySchedulePreviewPresenter
  include ActionView::Helpers::UrlHelper

  attr_reader :day, :location, :preview, :scheduling_period

  def initialize(scheduling_period, startdate=nil)
    @scheduling_period = scheduling_period
    @day = startdate.present? ? Date.parse(startdate.to_s) : first_day
    @location = scheduling_period.location
    @preview = true
  end

  def shifts_for(day)
    shifts_by_day_hash[day.to_i]
  end

  def weekly_schedule_tab
    link_to(
      "<span class='oi oi-grid-three-up'></span>".html_safe,
      routes.remote_location_scheduling_period_path(
        scheduling_period.location,
        scheduling_period,
        date: day.to_s,
        schedule_preview_view: "week",
        format: :js
      ),
      remote: true
    )
  end

  def day_to_open
    day.to_s(:integer).to_i || day_keys.first
  end

  def first_day
    Date.parse(scheduling_period.start_date.to_s)
  end

  def start_date
    Date.parse(scheduling_period.start_date.to_s)
  end

  def end_date
    Date.parse(scheduling_period.end_date.to_s)
  end

  def day_keys
    (start_date..end_date).map { |date| date.to_s(:integer).to_i }
  end

  def print_tab
  end

  def shifts
    scheduling_period.in_progress_shifts.includes(:user)
  end

  private

  def build_shift_hash
    day_keys.inject({}) do |object, day|
      object[day] = shifts.select { |shift| shift.date == day }
      object
    end
  end

  def routes
    Rails.application.routes.url_helpers
  end

  def shifts_by_day_hash
    @_shifts_by_day_hash ||= build_shift_hash
  end
end
