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
          user_id: d[0],
          user: d[1],
          date: d[2],
          value: d[3]
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
        where(date: (DateAndTime::Parser.number(@date_start))..(DateAndTime::Parser.number(@date_end))).order('user_id, date').
        collect{|shift| [shift.user.id, shift.user, shift.date, shift.shift_length]}
    end
  end
end
