module Calendar
  class WeeklySchedulePresenter < BasePresenter
    attr_reader :location

    def beginning_of_week
      DateAndTime::WeekDates.for(date).beginning_of_week
    end

    def container_classes(date)
      classes = ["shift-container"]

      if date.to_s(:integer).to_i < location_time.to_s(:day_integer).to_i
        classes.push "past-date"
      elsif today?(date)
        classes.push "today"
      end

      classes.join(" ")
    end

    def date_range
      (beginning_of_week..end_of_week)
    end

    def employees
      location.users
    end

    def needs_published?
      # shared
      false
    end

    def partial_name
      "calendars/weekly_schedule"
    end

    def shifts_for(user, day)
      shift_map["#{user.id}-#{day.to_s(:integer)}"]
    end

    def today?(date)
      date.to_s(:integer).to_i == location_time.to_s(:day_integer).to_i
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
                                            manage: manage?,
                                            day_start: 0))
      end

      result
    end

    def date_range_integers
      beginning_of_week.to_s(:integer).to_i..end_of_week.to_s(:integer).to_i
    end

    def end_of_week
      DateAndTime::WeekDates.for(date).end_of_week
    end

    def location_time
      DateAndTime::LocationTime.for(location)
    end

    def shift_map
      @_shift_map ||= build_shift_map
    end

    def shifts
      @_shifts ||= find_shifts.map do |shift|
        ShiftPresenter.new(shift: shift,
                           manage: manage?,
                           day_start: 0)
      end
    end

    def find_shifts
      @_raw_shifts ||= Shifts::Finders::ByWeek.
        new(date: date, in_progress: true, location: location).
        find
    end
  end
end
