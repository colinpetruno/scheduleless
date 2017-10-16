class Trade < ApplicationRecord
  belongs_to :location
  belongs_to :shift
  belongs_to :traded_with, class_name: "User"
  belongs_to :user

  has_many :offers

  enum status: {
    available: 0,
    completed: 1
  }

  after_create :send_notification

  private

  def send_notification
    Notifications::Trades::CreatedJob.perform_later(self.id)
  end
end
