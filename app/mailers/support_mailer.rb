class SupportMailer < ApplicationMailer
  default from: "notifications@scheduleless.com"

  def lead(lead)
    @lead = lead
    @user = lead.user
    @company = @user.company

    mail(to: "support@scheduleless.com", subject: "Customer Lead: #{@company.name}")
  end

  def new_schedule_generated(scheduling_period)
    @scheduling_period = scheduling_period

    mail(to: "support@scheduleless.com", subject: "New Schedule Generated")
  end

  def new_signup(user)
    @company = user.company
    @user = user

    mail(to: "support@scheduleless.com", subject: "Customer Sign Up: #{@company.name}")
  end
end
