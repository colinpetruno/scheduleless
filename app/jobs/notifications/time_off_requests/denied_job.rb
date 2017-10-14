module Notifications
  module TimeOffRequests
    class DeniedJob < ApplicationJob
      def perform(time_off_request_id)
        @time_off_request = TimeOffRequest.find(time_off_request_id)
        user = @time_off_request.user

        begin
          PushNotifications::TimeOffRequests::Denied.
              new(user: user, time_off_request: time_off_request).
              notify

            NotificationsMailer.
              time_off_request_denied(user, time_off_request).
              deliver
        rescue StandardError => error
          Bugsnag.notify(error)
          raise error
        end
      end
    end
  end
end
