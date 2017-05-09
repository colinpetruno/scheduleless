class Company < ApplicationRecord
  has_many :credit_cards
  has_many :locations
  has_many :popular_times, as: :popular
  has_many :positions
  has_many :schedule_rules
  has_many :users
  has_many :shifts

  has_one :preference, as: :preferable
  has_one :subscription

  validates :name, presence: true

  accepts_nested_attributes_for :shifts, :users

  before_create :setup_stripe_customer

  def preference
    super || create_preference
  end

  def subscription
    super || create_subscription
  end

  private

  def setup_stripe_customer
    StripeCustomer.for(self).create
    StripeSubscription.for(subscription).create
  end
end
