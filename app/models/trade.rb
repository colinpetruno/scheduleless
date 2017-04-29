class Trade < ApplicationRecord
  belongs_to :shift
  has_many :offers

  enum status: {
    completed: 1,
    open: 0
  }
end
