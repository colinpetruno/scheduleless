module PushNotifications
  module TimeOffRequests
    class Created < Base
      def initialize(user:, time_off_request:)
        @user = user
        @time_off_request = time_off_request
      end

      def message
        I18n.t("models.push_notifications.#{translation_key}.message",
               user_name: time_off_request.user.full_name,
               dates: time_off_request.label)
      end

      private

      attr_reader :user, :time_off_request

      def translation_key
        "time_off_requests.created"
      end
    end
  end
end
