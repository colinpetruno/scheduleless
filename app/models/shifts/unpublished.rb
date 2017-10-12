module Shifts
  class Unpublished
    def self.for(location)
      new(location).present?
    end

    def initialize(location)
      @location = location
    end

    def present?
      shifts.exists?
    end

    def shifts
      @_shifts ||= InProgressShift.
        where(location_id: location.id,
              edited: true,
              date: (date_integer..Float::INFINITY))
    end

    private

    attr_reader :location

    def date_integer
      DateAndTime::LocationTime.new(location: location).current_date_integer
    end
  end
end
