module PushNotifications
  class EmployeeJoinedLocation < Base
    def initialize(user:, new_employee:)
      @new_employee = new_employee
      @user = user
    end

    def title
      I18n.t("models.push_notifications.#{translation_key}.title")
    end

    def message
      I18n.
        t(
          "models.push_notifications.#{translation_key}.message",
          user_name: "#{@new_employee.given_name} #{@new_employee.family_name}".strip
        )
    end
  end
end
