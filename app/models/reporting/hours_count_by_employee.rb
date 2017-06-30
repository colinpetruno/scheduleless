module Reporting
  class HoursCountByEmployee
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
          user: d[:user],
          value: d[:value]
        }
      end
    end

    private

    attr_reader :location

    def data
      query
    end

    def query
      result = location.shifts.
        joins(:user).
        where(date: (DateParser.number(@date_start))..(DateParser.number(@date_end))).
        group(:user).sum("minute_end - minute_start")
      result.map do |user, value|
        {
          user: user,
          value: value
        }
      end
    end
  end
end
