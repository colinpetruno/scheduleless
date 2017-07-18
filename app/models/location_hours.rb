class LocationHours
  DAYS = {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }

  def self.for(location)
    new(location: location)
  end

  def initialize(location:)
    @location = location
  end

  def closed?
  end

  def open?
  end

  private

  attr_reader :location
end
