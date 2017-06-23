module PushNotifications
  class CancelledShift < Base
    def initialize(shift:, user:)
      @shift = shift
      @user = user
    end

    def title
      I18n.t("models.push_notifications.#{translation_key}.title")
    end

    def message
      I18n.
        t(
          "models.push_notifications.#{translation_key}.message",
          user_name: "#{@shift.user.given_name} #{@shift.user.family_name}".strip,
          shift_time: @shift.selection_label
        )
    end
  end
end
