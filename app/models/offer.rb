class Offer < ApplicationRecord
  belongs_to :company
  belongs_to :offered_shift, class_name: "Shift"
  belongs_to :trade
  belongs_to :user

  enum state: {
    offered: 0,
    declined: 1,
    waiting_approval: 3,
    not_approved: 4,
    completed: 5
  }

  def for_shift
    trade.shift
  end
end
