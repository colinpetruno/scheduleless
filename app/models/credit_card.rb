class CreditCard < ApplicationRecord
  belongs_to :company

  has_many :subscriptions
end
