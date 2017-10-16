module Notifications
  module TimeOffRequests
    class CreatedJob < ApplicationJob
      def perform(time_off_request_id)
        @time_off_request = TimeOffRequest.find(time_off_request_id)

        users_to_alert.map do |user|
          begin
            PushNotifications::TimeOffRequests::Created.
              new(user: user, time_off_request: time_off_request).
              notify

            if Users::Emailable.for(user)
              NotificationsMailer.
                new_time_off_approval(user, time_off_request).
                deliver
            end
          rescue StandardError => error
            Bugsnag.notify(error)
          end
        end
      end

      private

      attr_reader :time_off_request

      def user
        time_off_request.user
      end

      def user_locations
        @_user_locations ||= user.locations
      end

      def users_to_alert
        user_locations.map do |location|
          UserFinder.new(location: location).location_admins
        end.flatten.uniq
      rescue StandardError => error
        Bugsnag.notify(error)
        []
      end
    end
  end
end
