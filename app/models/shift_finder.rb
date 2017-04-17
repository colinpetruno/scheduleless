class ShiftFinder
  def self.for(user)
    new(user:user)
  end

  def initialize(user:)
    @user = user
  end

  def next
    future.first
  end

  def future
    all.where(date: (current_day..Float::INFINITY), minute_start: (current_minute..1440))
  end

  def all
    Shift.
      where(user_location_id: user_location_ids).
      order(:date, :minute_start)
  end

  private

  attr_reader :user

  def current_day
    Date.today.to_s(:number).to_i
  end

  def current_minute
    (Time.now.hour * 60) + Time.now.min
  end

  def user_location_ids
    user.user_locations.pluck(:id)
  end
end
