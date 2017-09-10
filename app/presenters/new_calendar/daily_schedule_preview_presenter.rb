module NewCalendar
  class DailySchedulePreviewPresenter < BasePresenter
    attr_reader :location

    def needs_published?
      find_shifts.exists?(edited: true)
    end

    def partial_name
      "new_calendars/daily_schedule"
    end

    def shift_view_width_class
      "shifts day-length-#{day_length}"
    end

    def shifts
      @_shifts ||= find_shifts.map do |shift|
        ShiftPresenter.new(shift: shift,
                           manage: true,
                           day_start: first_shift.minute_start)
      end
    end

    def shifts_for(user)
      # binding.pry
      user_shift_map.by(user)
    end

    def users
      @_users ||= location.users.order(:given_name)
    end

    private

    attr_reader :date, :user

    def day_length
      day_end - day_start
    end

    def day_end
      if last_shift.minute_start > last_shift.minute_end
        1440
      else
        last_shift.minute_end
      end
    rescue
      LocationHours.for(location).close(date.wday)
    end

    def day_start
      first_shift.minute_start
    rescue
      LocationHours.for(location).open(date.wday)
    end

    def first_shift
      find_shifts.first
    end

    def last_shift
      @_last_shift ||= LastShiftLocator.new(shifts: find_shifts).find
    end

    def find_shifts
      @_raw_shifts ||= location.
        in_progress_shifts.
        where(date: date.to_s(:integer).to_i).
        includes(:user).
        order(:date, :minute_start)
    end

    def user_shift_map
      @_user_shift_map ||= UserShiftMap.for(shifts)
    end
  end
end
