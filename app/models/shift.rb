class Shift < ApplicationRecord
  belongs_to :user_location
  belongs_to :company

  has_one :location, through: :user_location

  accepts_nested_attributes_for :company, :user_location
end
