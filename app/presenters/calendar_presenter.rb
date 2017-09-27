class CalendarPresenter
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  attr_reader :day, :format, :location, :month

  def initialize(day: Date.today, location:, month: nil, schedule_start: "monday")
    @day = day.is_a?(Date) ? day : Date.parse(day.to_s)
    @location = location
    @month = set_month(day, month)
    @schedule_start = schedule_start
  end

  def days
    week_dates.days_abbr
  end

  def day_block(date)
    content_tag(:div, class: classes_for(date)) do
      link_to(
        date.day,
        routes.location_calendar_path(
          location,
          date: date.to_s
        )
      )
    end
  end

  def month_link_disabled?(month)
    # ~ 6 months
    (Date.today - month).to_i.abs > 187
  end

  def next_month
    (month + 1.month)
  end

  def next_month_url
    routes.
      remote_calendar_location_calendar_sidebar_path(
        location,
         date: day.to_s(:integer),
         month: next_month.to_s(:integer)
      )
  end

  def previous_month
    (month - 1.month)
  end

  def previous_month_url
    routes.
      remote_calendar_location_calendar_sidebar_path(
        location,
        date: day.to_s(:integer),
        month: previous_month.to_s(:integer)
      )
  end

  def today?(date)
    Date.today == date
  end

  def start_day
    month.beginning_of_month.beginning_of_week(schedule_start)
  end

  def end_day
    month.end_of_month.end_of_week(schedule_start)
  end

  def weeks
    (start_day..end_day).to_a.in_groups_of(7)
  end

  private

  attr_accessor :output_buffer, :schedule_start

  def classes_for(date)
    class_names = [date.to_s]

    if today?(date)
      class_names.push("today")
    end

    if day == date
      class_names.push("selected-day")
    end

    class_names.join(" ")
  end

  def label_key
    if format == :small
     "date.day_initials"
    else
     "date.day_names"
    end
  end

  def routes
    Rails.application.routes.url_helpers
  end

  def set_month(day, month)
    if month.blank?
      day
    else
      month.is_a?(Date) ? month : Date.parse(month.to_s)
    end
  end

  def week_dates
    @_week_dates ||= DateAndTime::WeekDates.
      new(date: day, start_day: schedule_start)
  end
end
