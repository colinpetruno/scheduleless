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
    ShiftFinder.for(location).on(date).worked_by(user).find
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
    ShiftFinder.for(location).on(date).find
  end
end
