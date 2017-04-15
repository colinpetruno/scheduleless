class ShiftFinder
  def self.for(user)
    new(user:user)
  end

  def initialize(user:)
    @user = user
  end

  def next
    all.first
  end

  def all
    Shift.
      where(user_location_id: user_location_ids).
      order(:date, :minute_start)
  end

  private

  attr_reader :user

  def user_location_ids
    user.user_locations.pluck(:id)
  end
end
