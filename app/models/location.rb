class Location < ApplicationRecord
  belongs_to :company
  has_many :user_locations
  has_many :users, through: :user_locations

  update_index "site_search#location", :self
end
