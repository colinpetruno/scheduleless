class EmployeePosition < ApplicationRecord
  belongs_to :user
  belongs_to :position

  def self.primary_for(user)
    user.primary_position || Position.new(name: "N/A")
  rescue ActiveRecord::RecordNotFound
    Position.new(name: "N/A")
  end
end
