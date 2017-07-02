class NotificationsMailer < ApplicationMailer
  default from: "support@scheduleless.com",
          reply_to: "support@scheduleless.com"

  def employee_joined_location(user, new_employee, location)
    @user = user
    @new_employee = new_employee
    @location = location

    mail(to: user.email)
  end

  def schedule_approved(user, scheduling_period)
    @location = scheduling_period.location
    @scheduling_period = scheduling_period
    @user = user

    mail(to: user.email)
  end

  def schedule_published(user, scheduling_period)
    @location = scheduling_period.location
    @scheduling_period = scheduling_period
    @user = user

    mail(to: user.email)
  end
end
