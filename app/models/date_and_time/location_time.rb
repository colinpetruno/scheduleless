module DateAndTime
  class LocationTime
    def self.for(location)
      new(location: location).current_time
    end

    def initialize(location:)
      @location = location
    end

    def current_time
      Time.now.in_time_zone(location.time_zone)
    end

    private

    attr_reader :location
  end
end
