module DateAndTime
  class TimeToMinutes
    def self.for(location)
      new(location: location)
    end

    def new(location:)
      @location = location
    end

    def minutes
      (location_time.hour * 60) + location_time.min
    end

    private

    attr_reader :location

    def location_time
      LoctionTime.for(location)
    end
  end
end
