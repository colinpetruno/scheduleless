class LocationSchedule
  def self.for(location)
    new(location: location)
  end

  def initialize(location:, date: Date.today)
    @location = location
    @date = date
  end

  def scheduled_users
    location.users
  end

  def shifts_for(user)
    user.shifts.where(location: location)
  end

  def shifts?
    shifts.present?
  end

  private

  attr_reader :date, :location

  def shifts
    @_shifts || find_shifts
  end

  def find_shifts
    ShiftFinder.for(location).on(date)
  end
end
