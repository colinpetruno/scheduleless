class Position < ApplicationRecord
  include NotDeletable

  belongs_to :company
  has_many :employee_positions
  has_many :schedule_rules
  has_many :users, through: :employee_positions

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }

  default_scope { where(deleted_at: nil) }
end
