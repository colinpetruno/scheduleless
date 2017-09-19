class InProgressShift < ApplicationRecord
  belongs_to :company
  belongs_to :scheduling_period
  belongs_to :location
  belongs_to :repeating_shift
  belongs_to :user

  has_many :shifts

  def publish(notify: true)
    Shifts::Publishers::SingleShift.
      new(in_progress_shift: self,
          notify: notify).
      publish
  end

  def repeating?
    repeating_shift_id.present?
  end

  def time_range
    "#{MinutesToTime.for(minute_start)}-#{MinutesToTime.for(minute_end)}"
  end
end
