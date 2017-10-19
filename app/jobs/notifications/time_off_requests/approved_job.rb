module Notifications
  module TimeOffRequests
    class ApprovedJob < ApplicationJob
      def perform(time_off_request_id)
        @time_off_request = TimeOffRequest.find(time_off_request_id)
        @user = @time_off_request.user

        begin
          PushNotifications::TimeOffRequests::Approved.
              new(user: @user, time_off_request: @time_off_request).
              notify

          if Users::Emailable.for(@user)
            NotificationsMailer.
              time_off_request_denied(@user, @time_off_request).
              deliver
          end
        rescue StandardError => error
          Bugsnag.notify(error)
          raise error
        end
      end
    end
  end
end

