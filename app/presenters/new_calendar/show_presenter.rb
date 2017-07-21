module NewCalendar
  class ShowPresenter
    attr_reader :location

    def initialize(date: Date.today, location:, user:)
      @date = date
      @location = location
      @user = user
    end

    def date_integer
      date.to_s(:integer)
    end

    def formatted_date
      date.to_s(:full_day_and_month)
    end

    def partial
      if published?
        "show"
      elsif scheduling_period.present? && manage?
        "show"
      else
        "not_yet_scheduled"
      end
    end

    def partial_presenter
      if published?
        DailySchedulePresenter.new(date: date, location: location, user: user)
      elsif scheduling_period.present? && manage?
        DailySchedulePreviewPresenter.new(date: date, location: location, user: user)
      else
        NotYetScheduledPresenter.new(date: date, location: location, user: user)
      end
    end

    def title
      # TODO: Translate
      if published?
        "Schedule For #{scheduling_period.label}"
      elsif scheduling_period.present? && manage?
        "Scheduling For #{scheduling_period.label}"
      else
        "Start A Schedule"
      end
    end

    private

    attr_reader :date, :user

    def manage?
      UserPermissions.for(user).manage?(location)
    end

    def published?
      scheduling_period.published? || scheduling_period.closed?
    rescue
      false
    end

    def scheduling_period
      SchedulingPeriod.for(date, location)
    end
  end
end
