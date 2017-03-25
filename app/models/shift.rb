class Shift < ApplicationRecord
  belongs_to :user_location
  belongs_to :company

  accepts_nested_attributes_for :company, :user_location
end
