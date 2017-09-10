class RepeatingShift < ApplicationRecord
  belongs_to :location
  belongs_to :position
  belongs_to :user

  def self.options
    [["Daily", 1], ["Weekly", 7], ["Bi-Weekly", 14]]
  end
end
