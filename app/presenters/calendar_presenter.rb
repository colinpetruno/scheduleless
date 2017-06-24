class CalendarPresenter
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  attr_reader :day, :location

  def initialize(day: Date.today, location:)
    @day = day
    @location = location
  end

  def day_block(date)
    content_tag(:div, class: classes_for(date)) do
      link_to(
        date.day,
        routes.location_daily_schedule_path(
          location,
          date: date.to_s,
          format: :js
        ),
        remote: true
      )
    end
  end

  def today?(date)
    Date.today == date
  end

  def start_day
    day.beginning_of_month.beginning_of_week(:sunday)
  end

  def end_day
    day.end_of_month.end_of_week(:sunday)
  end

  def weeks
    (start_day..end_day).to_a.in_groups_of(7)
  end

  private

  attr_accessor :output_buffer

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

  def routes
    Rails.application.routes.url_helpers
  end
end
