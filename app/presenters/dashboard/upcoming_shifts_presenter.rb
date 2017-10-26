module Dashboard
  class UpcomingShiftsPresenter
    def initialize(user)
      @user = user
    end

    def displayable?
      user.locations.present? && unsorted_shifts.present?
    end

    def month_keys
      shifts_by_month.
        keys.
        partition { |i| i >= location_time.current_month_integer }.
        flatten
    end

    def shifts_for(month)
      shifts_by_month[month]
    end

    private

    attr_reader :user

    def current_date
      location_time.current_date_integer
    end

    def location
      @_location = Location.default_for(user)
    end

    def location_time
      @_location_time ||= DateAndTime::LocationTime.new(location: location)
    end

    def shifts_by_month
      @_shifts ||= unsorted_shifts.inject({}) do |hash, shift|
        month_integer = DateAndTime::Parser.new(date: shift.date).month_number.to_i
        hash[month_integer] = [] if hash[month_integer].blank?

        hash[month_integer].push(shift)
        hash
      end
    end

    def unsorted_shifts
      @_unsorted_shifts ||= Shifts::Finder.
        for(user).
        future.
        includes(:location, :position).
        first(4).
        find
    end
  end
end
