module Reporting
  class HoursWorkedOverTime
    def self.for(location, date_start, date_end)
      new(location: location, date_start: date_start, date_end: date_end)
    end

    def initialize(location:, date_start:, date_end:)
      @location = location
      @date_start = date_start
      @date_end = date_end
    end

    def as_json(_options={})
      data.map do |d|
        {
          user_id: d.shift.user_id,
          user: d.shift.user,
          date: d.shift.date,
          value: d.shift.shift_length
        }
      end
    end

    private

    attr_reader :location

    def data
      query
    end

    def query
      location.shifts.
        group(:user_id, :date).
        select(:user_id, :date, 'SUM(CASE WHEN minute_start < minute_end THEN minute_end - minute_start ELSE 0 END) as shift_length').
        where(date: (DateParser.number(@date_start))..(DateParser.number(@date_end))).order('user_id, date').
        collect{|shift| Reporting::ShiftSeriesLength.new(shift)}
    end
  end
end
