class EmailCapture < ApplicationRecord
  validates :email, presence: true, length: { minimum: 3, maximum: 200 }
end
