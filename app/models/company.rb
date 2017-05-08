class Company < ApplicationRecord
  has_many :locations
  has_many :popular_times, as: :popular
  has_many :positions
  has_many :schedule_rules
  has_many :users
  has_many :shifts
  has_one :preference, as: :preferable

  validates :name, presence: true

  accepts_nested_attributes_for :shifts, :users

  def preference
    super || create_preference
  end
end
