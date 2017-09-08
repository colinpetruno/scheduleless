module DateAndTime
  class LocationTime
    def self.for(location)
      new(location: location).current_time
    end

    def initialize(location:)
      @location = location
    end

    def current_date_integer
      current_time.to_s(:day_integer).to_i
    end

    def current_day_integer
      current_time.wday
    end

    def current_time
      Time.now.in_time_zone(location.time_zone)
    end

    def current_time_minutes
      (current_time.hour * 60) + current_time.min
    end

    private

    attr_reader :location
  end
end
