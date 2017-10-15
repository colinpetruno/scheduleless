module DateAndTime
  class WeekDates
    # TODO: this class is very similar to SchedulePeriod, we could consolidate
    def self.for(date)
      new(date: date)
    end

    def initialize(date: Date.today, start_day: "monday")
      @date = date.is_a?(Date) ? date : Date.parse(date.to_s)
      @start_day = start_day.downcase.to_sym
    end

    def beginning_of_week(format = :date)
      if format == :date
        date.beginning_of_week(start_day)
      else
        date.beginning_of_week(start_day).to_s(:integer).to_i
      end
    end

    def days
      I18n.t("date.day_names").rotate(start_integer)
    end

    def days_abbr
      I18n.t("date.day_initials").rotate(start_integer)
    end

    def end_of_week(format = :date)
      if format == :date
        date.end_of_week(start_day)
      else
        date.end_of_week(start_day).to_s(:integer).to_i
      end
    end

    private

    attr_reader :date, :start_day

    def start_integer
      I18n.t("date.day_names").map(&:downcase).map(&:to_sym).index(start_day)
    end
  end
end
