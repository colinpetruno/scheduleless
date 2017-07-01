class NotificationsMailer < ApplicationMailer
  default from: "support@scheduleless.com",
          reply_to: "support@scheduleless.com"

  def employee_joined_location(user, new_employee, location)
    @user = user
    @new_employee = new_employee
    @location = location

    mail(to: user.email)
  end
end
