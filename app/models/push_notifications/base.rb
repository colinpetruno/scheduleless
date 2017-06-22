module PushNotifications
  class Base
    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def message
      I18n.t("models.push_notifications.#{translation_key}.message")
    end

    def send
      PushNotification.
        new(message: message, recipient: user, title: title).
        send
    end

    def title
      I18n.t("models.push_notifications.#{translation_key}.title")
    end

    private

    def translation_key
      self.class.name.demodulize.underscore
    end
  end
end
