class Company < ApplicationRecord
  has_many :locations
  has_many :popular_times, as: :popular
  has_many :positions
  has_many :schedule_rules
  has_many :users
  has_many :shifts
  has_one :company_preference

  validates :name, presence: true

  accepts_nested_attributes_for :shifts, :users

  def company_preference
    super || create_company_preference
  end
end
