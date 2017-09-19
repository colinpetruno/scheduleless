module DateAndTime
  class WeekDates
    def self.for(date)
      new(date: date)
    end

    def initialize(date: Date.today, start_day: "monday")
      @date = date.is_a?(Date) ? date : Date.parse(date.to_s)
      @start_day = start_day.to_sym
    end

    def beginning_of_week(format = :date)
      if format == :date
        date.beginning_of_week(start_day)
      else
        date.beginning_of_week(start_day).to_s(:integer).to_i
      end
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
  end
end
