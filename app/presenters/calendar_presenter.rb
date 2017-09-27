class CalendarPresenter
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  attr_reader :day, :format, :location

  def initialize(company:, day: Date.today, format: :large, location:)
    @company = company
    @day = day
    @format = format # TODO: this can prob be removed now
    @location = location
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

  def today?(date)
    Date.today == date
  end

  def start_day
    day.beginning_of_month.beginning_of_week(company.schedule_start)
  end

  def end_day
    day.end_of_month.end_of_week(company.schedule_start)
  end

  def weeks
    (start_day..end_day).to_a.in_groups_of(7)
  end

  private

  attr_accessor :company, :output_buffer

  def classes_for(date)
    class_names = date.to_s

    if today?(date)
      class_names = class_names + " today"
    end

    if day == date
      class_names = class_names + " selected-day"
    end

    class_names
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

  def week_dates
    @_week_dates ||= DateAndTime::WeekDates.
      new(date: day, start_day: company.schedule_start)
  end
end
