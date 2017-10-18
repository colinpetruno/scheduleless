module Calendar
  class BasePresenter
    def initialize(date: Date.today, location:, user:, mode: "scheduling")
      @date = date.is_a?(Date) ? date : Date.parse(date.to_s)
      @location = location
      @mode = mode
      @user = user
    end

    def schedulable?(date)
      current_location_date <= date.to_s(:integer).to_i && display_in_progress?
    end

    def date_integer
      date.to_s(:integer).to_i
    end

    def display_in_progress?
      # its in scheduling mode and the person can actually manage the location
      if mode == "scheduling" && manage?
        true
      else
        false
      end
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
                                                           published: !display_in_progress?,
                                                           date: @date)
    end

    private

    attr_reader :mode

    def company
      @_company ||= location.company
    end

    def current_location_date
      DateAndTime::LocationTime.new(location: location).current_date_integer
    end
  end
end
