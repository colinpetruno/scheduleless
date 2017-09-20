class RepeatingShift < ApplicationRecord
  belongs_to :location
  belongs_to :position
  belongs_to :user

  has_many :in_progress_shifts

  after_create :update_in_progress_shift

  after_initialize do |repeating_shift|
    if repeating_shift.user.present?
      repeating_shift.position_id = user.primary_position_id
    end
  end

  def self.options
    [["Day", 1], ["Week", 7], ["Other Week", 14]]
  end

  def preview_user_id
    super || self.user_id
  end

  def preview_position_id
    super || self.position_id
  end

  def preview_start_date
    super || self.start_date
  end

  def preview_repeat_frequency
    super || self.repeat_frequency
  end

  def preview_location_id
    super || self.location_id
  end

  def preview_minute_start
    super || self.minute_start
  end

  def preview_minute_end
    super || self.minute_end
  end

  private

  def update_in_progress_shift
    InProgressShift.
      find(self.in_progress_shift_id).
      update(repeating_shift_id: self.id)
  end
end
