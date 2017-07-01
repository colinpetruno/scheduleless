module Notifications
  class EmployeeJoinedLocationJob < ApplicationJob
    queue_as :default

    def perform(user_id, location_id)
      @user = User.find(user_id) # the new employee
      @location = Location.find(location_id)

      users_to_alert.map do |user|
        begin
          # send email
          NotificationMailer.
            employee_joined_location(user, @user, @location).
            deliver

          # send push notification
          PushNotifications::EmployeeJoinedLocation.new(
            user: user,
            new_employee: @user
          ).notify
        rescue StandardError => error
          Bugsnag.notify(error)
        end
      end
    end

    private

    def users_to_alert
      UserFinder.new(location: @location).location_admin
    end
  end
end
