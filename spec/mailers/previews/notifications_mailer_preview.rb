class NotificationsMailerPreview < ActionMailer::Preview
  def employee_joined_location
    u = User.first
    u2 = User.second
    l = Location.first

    NotificationsMailer.employee_joined_location(u, u2, l)
  end

  def schedule_approved
    u = User.first
    sp = SchedulingPeriod.last

    NotificationsMailer.schedule_approved(u, sp)
  end
end
