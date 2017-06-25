class WeekSchedulePreviewPresenter
  include ActionView::Helpers::UrlHelper

  attr_reader :day, :location, :preview, :scheduling_period

  def initialize(scheduling_period, startdate=nil)
    @scheduling_period = scheduling_period
    @day = startdate.present? ? Date.parse(startdate.to_s) : first_day
    @location = scheduling_period.location
    @preview = true
  end

  def day_headers
    days.map do |day|
      content_tag(:div, day.to_s(:month_day))
    end.join.html_safe
  end

  def days
    (start_day..end_day)
  end

  def shifts_for(user, date)
    key = "#{user.id}_#{date.to_s(:integer)}"

    shift_map[key]
  end

  def start_day
    day
  end

  def users
    scheduling_period.location.users.order(:family_name)
  end

  def week_ranges
    date_holder = first_day - 1.day

    (1..weeks).map do |i|
      range = [(date_holder + 1.day), (date_holder + 7.days)]
      date_holder = date_holder + 7.days
      range
    end
  end

  def daily_schedule_tab
    link_to(
      "<span class='oi oi-project'></span>".html_safe,
      routes.remote_location_scheduling_period_path(
        scheduling_period.location,
        scheduling_period,
        date: day.to_s,
        schedule_preview_view: "day",
        format: :js
      ),
      remote: true
    )
  end

  def print_tab
  end

  private

  def build_shift_map
    map = {}

    shifts.each do |shift|
      key = "#{shift.user_id.to_i}_#{shift.date}"
      if map[key].present?
        map[key].push(shift)
      else
        map[key] = [shift]
      end
    end

    map
  end

  def end_day
    day + 6.days
  end

  def first_day
    Date.parse(scheduling_period.start_date.to_s)
  end

  def last_day
    Date.parse(scheduling_period.end_date.to_s)
  end

  def routes
    Rails.application.routes.url_helpers
  end

  def shift_map
    @_shift_map ||= build_shift_map
  end

  def shifts
    scheduling_period.in_progress_shifts
  end

  def weeks
    ( (last_day - first_day).to_f / 7).ceil
  end
end
