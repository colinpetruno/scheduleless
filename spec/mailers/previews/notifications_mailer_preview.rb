class NotificationsMailerPreview < ActionMailer::Preview
  def employee_joined_location
    u = User.first
    u2 = User.second
    l = Location.first

    NotificationsMailer.employee_joined_location(u, u2, l)
  end
end
