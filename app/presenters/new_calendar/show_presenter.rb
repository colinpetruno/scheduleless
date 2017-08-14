module NewCalendar
  class ShowPresenter
    attr_reader :location

    def initialize(date: nil, location:, user:)
      @location = location
      @date = date || current_date
      @user = user
    end

    def current_date
      DateAndTime::LocationTime.for(location).to_date
    end

    def date_integer
      date.to_s(:integer)
    end

    def formatted_date
      date.to_s(:full_day_and_month)
    end

    def next_day_url
      routes.location_new_calendar_path(location, date: date + 1.day)
    end

    def partial
#      if published?
        #"show"
      #elsif scheduling_period.present? && manage?
        #"show"
      #else
        #"not_yet_scheduled"
      #end

      "show"
    end

    def previous_day_url
      routes.location_new_calendar_path(location, date: date - 1.day)
    end

    def partial_presenter
      # if published?
        # DailySchedulePresenter.new(date: date, location: location, user: user)
      # elsif scheduling_period.present? && manage?
      # else
        # NotYetScheduledPresenter.new(date: date, location: location, user: user)
        # end
      #

      DailySchedulePreviewPresenter.new(date: date, location: location, user: user)
    end

#    def scheduling_period
      #SchedulingPeriod.for(date, location)
    #end

    def selected_date
      date
    end

    def title
      # TODO: Translate
#      if published?
        #"Schedule For #{scheduling_period.label}"
      #elsif scheduling_period.present? && manage?
        #"Scheduling For #{scheduling_period.label}"
      #else
        #"Start A Schedule"
      #end
      "Title Goes Here"
    end

    private

    attr_reader :date, :user

    def manage?
      UserPermissions.for(user).manage?(location)
    end

#    def published?
      #scheduling_period.published? || scheduling_period.closed?
    #rescue
      #false
    #end

    def routes
      Rails.application.routes.url_helpers
    end
  end
end
