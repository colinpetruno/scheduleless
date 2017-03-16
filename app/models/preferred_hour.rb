class PreferredHour < ApplicationRecord
  def self.default_scope
    order(:day)
  end

  def self.build_for(user)
    monday = 1
    sunday = 7

    user.preferred_hours.build((monday..sunday).map { |day| { day: day }})
  end
end
