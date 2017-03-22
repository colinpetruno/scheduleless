class Company < ApplicationRecord
  has_many :locations
  has_many :positions
  has_many :schedule_rules
  has_many :users
  has_one :company_preference

  validates :name, presence: true

  accepts_nested_attributes_for :users
end
