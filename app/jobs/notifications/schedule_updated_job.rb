module Notifications
  class ScheduleUpdatedJob < ApplicationJob
    def perform(user_id, notifications)
      @user = User.find(user_id)
      @notifications = Marshal.load(notifications)

      if @user.invitation_state == :awaiting_invite
        # send invite if they haven't been invited.
        EmployeeInviteJob.perform @user.id
      end

      PushNotifications::ScheduleUpdated.
        new(user: @user, notifications: @notifications).
        notify

      if Users::Emailable.for(@user)
        ScheduleMailer.schedule_updated(@user, @notifications).deliver
      end
    end
  end
end
