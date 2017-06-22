class PushNotificationSenderJob < ApplicationJob
  queue_as :default

  # notification_name is a string, ie: "schedule_published"
  def perform(user_id, notification_name)
    @user = User.find user_id
    @notification_name = notification_name

    send_notification
  end

  def send_notification
    push_notification_class.new(user: @user).send
  end

  private

  def push_notification_class
    "PushNotifications::#{@notification_name.to_s.camelcase}".constantize
  end
end
