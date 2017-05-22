class Position < ApplicationRecord
  include NotDeletable

  belongs_to :company
  has_many :employee_positions
  has_many :schedule_rules, through: :employee_positions
  has_many :users, through: :employee_positions

  default_scope { where(deleted_at: nil) }
end
