class InProgressShift < ApplicationRecord
  belongs_to :company
  belongs_to :scheduling_period
  belongs_to :location
  belongs_to :user
end
