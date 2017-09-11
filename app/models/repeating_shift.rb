class RepeatingShift < ApplicationRecord
  belongs_to :location
  belongs_to :position
  belongs_to :user

  after_initialize do |repeating_shift|
    if repeating_shift.user.present?
      repeating_shift.position_id = user.primary_position_id
    end
  end

  def self.options
    [["Day", 1], ["Week", 7], ["Other Week", 14]]
  end
end
