class EmployeePosition < ApplicationRecord
  belongs_to :user
  belongs_to :position
end
