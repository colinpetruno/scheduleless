class Offer < ApplicationRecord
  belongs_to :company
  belongs_to :offered_shift, class_name: "Shift"
  belongs_to :trade
  belongs_to :user

  enum state: {
    offered: 0,
    accepted: 1,
    declined: 2,
    waiting_approval: 3
  }

  def for_shift
    trade.shift
  end
end
