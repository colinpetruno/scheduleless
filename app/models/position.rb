class Position < ApplicationRecord
  belongs_to :company
  has_many :schedule_rules
end
