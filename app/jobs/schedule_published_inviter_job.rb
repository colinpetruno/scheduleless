class SchedulePublishedInviterJob < ApplicationJob
  queue_as :default

  def perform(schedule_period_id)
    @scheduling_period = SchedulingPeriod.find(schedule_period_id)
    @users = User.
      joins(:in_progress_shifts).
      where(in_progress_shifts: { scheduling_period_id: schedule_period_id })

    @users.map do |user|
      if user.invitation_state == :awaiting_invite
        EmployeeInviteJob.perform_later user.id
      elsif user.invitation_state == :active
        begin
          PushNotificationSenderJob.
            perform_later(user.id, :schedule_published)

          NotificationsMailer.
            schedule_published(user, @scheduling_period).
            deliver
        rescue StandardError => error
          Bugsnag.notify(error)
        end
      end
    end
  end
end
