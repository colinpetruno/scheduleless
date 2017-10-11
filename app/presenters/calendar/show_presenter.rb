module Calendar
  class ShowPresenter
    attr_reader :location

    def initialize(date: nil, location:, user:, view: :daily)
      @location = location
      @date = date || current_date
      @user = user
      @view = view
    end

    def current_date
      location_datetime.current_time.to_date
    end

    def date_integer
      date.to_s(:integer).to_i
    end

    def formatted_date
      date.to_s(:full_day_and_month)
    end

    def next_day_url
      if view.to_sym == :daily
        routes.location_calendar_path(location, date: date + 1.day)
      else
        routes.location_calendar_path(location, date: date + 7.days)
      end
    end

    def previous_day_url
      if view.to_sym == :daily
        routes.location_calendar_path(location, date: date - 1.day)
      else
        routes.location_calendar_path(location, date: date - 7.days)
      end
    end

    def partial_presenter
      @_partial_presenter ||= presenter_class.
        new(date: date, location: location, user: user)
    end

    def selected_date
      date
    end

    def title
      if view.to_sym == :daily
        formatted_date
      else
        week = DateAndTime::WeekDates.new(date: date,
                                          start_day: company.schedule_start)
        beginning = week.beginning_of_week.to_s(:full_day_and_month)
        end_of_week = week.end_of_week.to_s(:full_day_and_month)

        "#{beginning} - #{end_of_week}"
      end
    end

    def toggle_link_options(format)
      if format.to_sym == view.to_sym
        { class: "selected" }
      else
        {}
      end
    end

    def unpublished_shifts?
      puts "unpublished query"
      @_unpublished_shifts ||= InProgressShift.
        where(location_id: location.id,
              edited: true,
              date: (date_integer..Float::INFINITY)).
        exists?
    end

    private

    attr_reader :date, :user, :view

    def company
      @_company ||= location.company
    end

    def location_datetime
      @_location_datetime ||= DateAndTime::LocationTime.new(location: location)
    end

    def manage?
      UserPermissions.for(user).manage?(location)
    end

    def presenter_class
      if view.to_sym == :daily
        DailySchedulePreviewPresenter
      else
        WeeklySchedulePresenter
      end
    end

    def routes
      Rails.application.routes.url_helpers
    end
  end
end
