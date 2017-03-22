class Position < ApplicationRecord
  belongs_to :company
  has_many :employee_positions
  has_many :schedule_rules, through: :employee_positions
  has_many :users, through: :employee_positions
end
