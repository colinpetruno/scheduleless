module NewCalendar
  class DailySchedulePresenter
    def initialize(date: Date.today, location:, user:)
      @date = date
      @location = location
      @user = user
    end

    def shifts
      if published?
      else
      end
    end

    private

    attr_reader :date, :location, :user

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
