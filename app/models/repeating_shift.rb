class RepeatingShift < ApplicationRecord
  belongs_to :location
  belongs_to :position
  belongs_to :user

  has_many :in_progress_shifts

  def self.options(include_blank: false)
    options = [["Day", 1], ["Week", 7], ["Other Week", 14]]
    options.unshift(["None", 0]) if include_blank
    options
  end

  def self.default_scope
    where(deleted_at: nil)
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

  def publish
    # this method is screwed up
    ActiveRecord::Base.transaction do
      update(minute_end: preview_minute_end,
             minute_start: preview_minute_start,
             location_id: preview_location_id,
             repeat_frequency: preview_repeat_frequency,
             position_id: preview_position_id,
             published: true,
             start_date: preview_start_date,
             user_id: preview_user_id)

      self.
        in_progress_shifts.
        update_all(minute_end: preview_minute_end,
                   minute_start: preview_minute_start,
                   position_id: preview_position_id,
                   user_id: preview_user_id,
                   # published: true,
                   edited: true)
    end
  end
end
