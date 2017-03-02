class Location < ApplicationRecord
  has_many :user_locations
  has_many :users, through: :user_locations
end
