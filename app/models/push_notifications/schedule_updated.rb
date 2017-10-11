module PushNotifications
  class ScheduleUpdated < Base
    def initialize(user:, notifications:)
      @notifications = notifications
      @user = user
    end

    def title
      I18n.t("models.push_notifications.#{translation_key}.title")
    end

    def message
      I18n.t("models.push_notifications.#{translation_key}.messages.#{message_key}")
    end

    private

    attr_reader :notifications, :user

    def message_key
      if notifications.length > 1
        "multiple_changes"
      else
        notifications.first.to_s
      end
    end
  end
end
