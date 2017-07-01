module Notifications
  class ScheduleApprovedJob < ApplicationJob
    queue_as :default

    def perform(scheduling_period_id)
      @scheduling_period = SchedulingPeriod.find scheduling_period_id
      @location = @scheduling_period.location

      users_to_notify.map do |user|
        begin
          send_push_to(user)
          send_email_to(user)
        rescue StandardError => error
          Bugsnag.notify(error)
        end
      end
    end

    private

    def send_push_to(user)
      PushNotifications::ScheduleApproved.
        new(scheduling_period: @scheduling_period, user: user).
        send
    end

    def send_email_to(user)
      NotificationsMailer.
        schedule_approved(user, @scheduling_period).
        deliver
    end

    def users_to_notify
      @_users ||= UserFinder.new(location: @location).admins_for_location
    end
  end
end
