module Dashboard
  class UpcomingShiftPresenter
    def initialize(user)
      @user = user
    end

    def checked_in?
      @_checked_in ||= upcoming_shift.checked_in?
    end

    def check_in_text
      if checked_in?
        "Check Out"
      else
        "Check In"
      end
    end

    def check_in_link
      if checked_in?
        routes.remote_dashboard_shift_check_out_path(upcoming_shift)
      else
        routes.remote_dashboard_shift_check_in_path(upcoming_shift)
      end
    end

    def day
      shift_time.day
    end

    def month
      shift_time.month
    end

    def time_range
      shift_time.time_range
    end

    def upcoming_shift
      @_upcoming_shift ||= ShiftFinder.for(user).next.find
    end

    private

    attr_reader :user

    def routes
      Rails.application.routes.url_helpers
    end

    def shift_time
      @_shift_time ||= DateAndTime::ShiftDateTime.for(upcoming_shift)
    end
  end
end
