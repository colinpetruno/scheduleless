class LocationSchedule
  def self.for(location)
    new(location: location)
  end

  def initialize(location:)
    @location = location
  end

  def scheduled_users
    location.users
  end

  def shifts_for(user)
    # TODO n+1 query elimination
    user_location = UserLocation.find_by(user_id: user.id, location_id: location.id)
    shifts.where(user_location_id: user_location.id)
  end

  private

  attr_reader :location

  def shifts
    @_shifts || find_shifts
  end

  def find_shifts
    ShiftFinder.for(location).on(Date.today)
  end
end
