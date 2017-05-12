class Trade < ApplicationRecord
  belongs_to :location
  belongs_to :shift
  belongs_to :traded_with, class_name: "User"
  has_many :offers

  enum status: {
    completed: 1,
    available: 0
  }
end
