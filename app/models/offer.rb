class Offer < ApplicationRecord
  belongs_to :company
  belongs_to :offered_shift, class_name: "Shift"
  belongs_to :trade
  belongs_to :user

  def for_shift
    trade.shift
  end
end
