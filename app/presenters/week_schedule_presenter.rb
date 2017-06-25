class WeekSchedulePresenter
  include ActionView::Helpers::UrlHelper

  attr_reader :day, :location, :preview, :shifts

  def initialize(day:, location:)
    @day = day
    @location = location
    @preview = false
  end

  def days
    (start_day..end_day)
  end

  def day_headers
    days.map do |day|
      content_tag(:div, day.to_s(:month_day))
    end.join.html_safe
  end

  def start_day
    day.beginning_of_week(:sunday)
  end

  def end_day
    day.end_of_week(:sunday)
  end

  def users
    location.users.order(:family_name)
  end

  def shifts_for(user, date)
    key = "#{user.id}_#{date.to_s(:integer)}"

    shift_map[key]
  end

  def daily_schedule_tab
    link_to(
      "<span class='oi oi-project'></span>".html_safe,
      routes.location_daily_schedule_path(
        location,
        date: day.to_s,
        view: "day",
        format: :js
      ),
      remote: true
    )
 end

  def print_tab
    link_to(
      "<span class=\"oi oi-print\"></span>".html_safe,
      routes.location_print_path(
        location,
        date: day.to_s
      ),
      target: "_blank"
    )
  end

  private

  def build_shift_map
    map = {}

    shifts.each do |shift|
      key = "#{shift.user_id}_#{shift.date}"
      if map[key].present?
        map[key].push(shift)
      else
        map[key] = [shift]
      end
    end

    map
  end

  def company
    location.company
  end

  def date_integer_range
    (start_day.to_s(:integer).to_i..end_day.to_s(:integer).to_i)
  end

  def routes
    Rails.application.routes.url_helpers
  end

  def shift_map
    @_shift_map ||= build_shift_map
  end

  def shifts
    company.shifts.where(date: date_integer_range, location_id: location.id)
  end
end
