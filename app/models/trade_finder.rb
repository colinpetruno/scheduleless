class TradeFinder
  def self.for(user)
    new(user: user)
  end

  def initialize(user:)
    @user = user
  end

  def find
    all
  end

  private

  def all
    Trade.where(location_id: user_location_ids)
  end

  def user_location_ids
    user.user_locations.pluck(:location_id)
  end

  attr_reader :user
end
