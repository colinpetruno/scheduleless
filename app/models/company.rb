class Company < ApplicationRecord
  has_many :users
  has_one :company_preference

  validates :name, presence: true

  accepts_nested_attributes_for :users
end
