class EmployeePosition < ApplicationRecord
  belongs_to :user
  belongs_to :position

  def self.primary_for(user)
    find_by!(user: user, primary: true).position
  rescue ActiveRecord::RecordNotFound
    Position.new(name: "N/A")
  end
end
