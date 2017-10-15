module Calendar
  class BasePresenter

    def initialize(date: Date.today, location:, user:)
      @date = date.is_a?(Date) ? date : Date.parse(date.to_s)
      @location = location
      @user = user
    end

    def schedulable?(date)
      current_location_date < date.to_s(:integer).to_i && manage?
    end

    def date_integer
      date.to_s(:integer).to_i
    end

    def manage?
      UserPermissions.for(@user).manage?(@location)
    end

    def full_week_wages
      @_full_week_wages = wages.for_full_week
    end

    def wages
      return unless Features.for(location.company).wages?

      @wages ||= Calculators::Wages::WeeklyForLocation.new(location: location,
                                                           date: @date)
    end

    private

    def current_location_date
      DateAndTime::LocationTime.new(location: location).current_date_integer
    end
  end
end
