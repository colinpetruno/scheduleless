class Location < ApplicationRecord
  belongs_to :company
  has_many :popular_times, as: :popular
  has_many :user_locations
  has_many :users, through: :user_locations

  update_index "site_search#location", :self

  def self.default_for(user)
    locations = user.locations

    locations.find_by(user_locations: { home: true }) || locations.first || new
  end
end
