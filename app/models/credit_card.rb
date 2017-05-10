class CreditCard < ApplicationRecord
  belongs_to :company

  has_many :subscriptions

  before_create :get_card_details

  private

  def get_card_details
    StripeCreditCard.for(self).create
  end
end
