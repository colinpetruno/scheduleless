class Preference < ApplicationRecord
  belongs_to :preferable, polymorphic: true

  validates :minimum_shift_length, inclusion: { in: (120..480) }
end
