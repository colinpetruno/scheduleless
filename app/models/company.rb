class Company < ApplicationRecord
  has_many :credit_cards
  has_many :locations
  has_many :popular_times, as: :popular
  has_many :positions
  has_many :schedule_rules, as: :ruleable
  has_many :scheduling_periods
  has_many :users
  has_many :shifts

  has_one :preference, as: :preferable
  has_one :schedule_setting
  has_one :subscription

  validates :name, presence: true, length: { minimum: 3, maximum: 150 }

  accepts_nested_attributes_for :shifts, :users

  after_create :setup_stripe_customer

  def self.size_options
    ["1-10 Employees", "11-20 Employees", "21-50 Employees",
     "50-100 Employees", "100+ Employees"]
  end

  def hash_key
    super || generate_hash_key
  end

  def preference
    super || create_preference
  end

  def schedule_setting
    super || create_schedule_setting
  end

  def subscription
    super || create_subscription
  end

  private

  def generate_hash_key
    key = SecureRandom.hex(6)
    update_column(:hash_key, key)
    key
  end

  def setup_stripe_customer
    if !Rails.env.test?
      StripeCustomer.for(self).create
      StripeSubscription.for(subscription).create
    end
  end
end
