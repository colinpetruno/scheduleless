class ScheduleMailer < ApplicationMailer
  default from: "support@scheduleless.com",
          reply_to: "support@scheduleless.com"

  def schedule_updated(user, notifications)
    @presenter = ScheduleMailers::ScheduleUpdatedPresenter.new(
      user: user,
      notifications: notifications
    )

    mail(to: user.email)
  end
end
