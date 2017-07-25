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

  def close(day)
    scheduling_hour_for(day).minute_schedulable_end
  rescue
    1440
  end

  def closed?
  end

  def open(day)
    scheduling_hour_for(day).minute_schedulable_start
  rescue
    0
  end

  def open?
  end

  private

  attr_reader :location

  def scheduling_hour_for(day)
    SchedulingHour.find_by(location_id: location.id, day: day)
  end
end
