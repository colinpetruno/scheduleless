module Dashboard
  class UpcomingShiftsPresenter
    def initialize(user)
      @user = user
    end

    def displayable?
      user.locations.present? && shifts.present?
    end

    def shifts
      @_shifts ||= Shifts::Finder.
        for(user).
        future.
        includes(:location, :position).
        first(4).
        find
    end

    private

    attr_reader :user

    def current_date
      DateAndTime::LocationTime.new(location: location).current_date_integer
    end

    def location
      @_location = Location.default_for(user)
    end
  end
end
