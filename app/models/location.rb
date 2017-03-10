class Location < ApplicationRecord
  belongs_to :company
  has_many :user_locations
  has_many :users, through: :user_locations
end
