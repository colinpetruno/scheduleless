module NewCalendar
  class WeeklySchedulePresenter
    attr_reader :location

    def initialize(date: Date.today, location:, user:)
      @date = date
      @location = location
      @user = user
    end

    def beginning_of_week
      # TODO: pull from company settings
      date.beginning_of_week(:monday)
    end

    def date_integer
      date.to_s(:integer).to_i
    end

    def date_range
      (beginning_of_week..end_of_week)
    end

    def employees
      location.users
    end

    def manage?
      # TODO: Fill out
      true
    end

    def needs_published?
      # shared
      false
    end

    def partial_name
      "new_calendars/weekly_schedule"
    end

    def shifts_for(user, day)
      shift_map["#{user.id}-#{day.to_s(:integer)}"]
    end

    private

    attr_reader :date, :user

    def build_shift_map
      result = {}

      find_shifts.map do |shift|
        key = "#{shift.user_id}-#{shift.date}"

        if result[key].blank?
          result[key] = []
        end

        result[key].push(ShiftPresenter.new(shift: shift,
                                            manage: true,
                                            day_start: 0))
      end

      result
    end

    def date_range_integers
      beginning_of_week.to_s(:integer).to_i..end_of_week.to_s(:integer).to_i
    end

    def end_of_week
      # TODO: pull from company settings
      date.end_of_week(:monday)
    end

    def shift_map
      @_shift_map ||= build_shift_map
    end

    def shifts
      @_shifts ||= find_shifts.map do |shift|
        ShiftPresenter.new(shift: shift,
                           manage: true,
                           day_start: 0)
      end
    end

    def find_shifts
      @_raw_shifts ||= location.
        in_progress_shifts.
        where(date: date_range_integers).
        includes(:user).
        order(:date, :minute_start)
    end
  end
end
