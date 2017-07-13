class Preference < ApplicationRecord
  belongs_to :preferable, polymorphic: true

  validates :break_length, presence: true
  validates :maximum_shift_length, presence: true
  validates :minimum_shift_length, inclusion: { in: (120..480) }
  validates :shift_overlap, presence: true
  validates :preferred_shift_length, presence: true

end
