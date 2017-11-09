module Calendar
  class WeeklySchedulePresenter < BasePresenter
    attr_reader :location

    def beginning_of_week
      schedule_period.start_date
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

    def date_label(date)
      day = I18n.t("date.abbr_day_names")[date.wday]
      date = date.to_s(:short_month_day)

      "#{day} #{date}"
    end

    def date_range
      (beginning_of_week..end_of_week)
    end

    def employees
      @_employees ||= UserFinder.new(location: location).by_location
    end

    def needs_published?
      # shared
      false
    end

    def partial_name
      "calendars/weekly_schedule"
    end

    def unassigned_shifts(day)
      shift_finder.unassigned_on(day).map do |shift|
        ShiftPresenter.new(shift: shift,
                           manage: manage?,
                           color: color_positions[shift.position_id],
                           day_start: 0)
      end
    end

    def shifts_for(user, day)
      shift_finder.for_user_on_date(user, day).map do |shift|
        ShiftPresenter.new(shift: shift,
                           manage: manage?,
                           day_start: 0,
                           color: color_positions[shift.position_id])
      end
    end

    def today?(date)
      date.to_s(:integer).to_i == location_time.to_s(:day_integer).to_i
    end

    def wages_for(lookup_date)
      wages.for_date(lookup_date)
    end

    private

    attr_reader :date, :user

    def date_range_integers
      beginning_of_week.to_s(:integer).to_i..end_of_week.to_s(:integer).to_i
    end

    def end_of_week
      schedule_period.end_date
    end

    def schedule_period
      @_schedule_period ||= SchedulePeriod.new(company: company, date: date)
    end

    def location_time
      DateAndTime::LocationTime.for(location)
    end

    def shift_finder
      @_shift_finder ||= Shifts::Finders::ByWeek.new(date: date,
                                                     in_progress: display_in_progress?,
                                                     location: location)
    end

    def week_dates
      @_week_dates ||= DateAndTime::WeekDates.for(date)
    end
  end
end
