class ScheduleMailerPreview < ActionMailer::Preview
  def schedule_updated
    u = User.first
    n = [:shift_added, :shift_cancelled, :shift_changed]

    ScheduleMailer.schedule_updated(u, n)
  end
end
