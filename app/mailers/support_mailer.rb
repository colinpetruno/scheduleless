class SupportMailer < ApplicationMailer
  default from: "notifications@scheduleless.com"

  def lead(lead)
    @lead = lead
    @user = lead.user
    @company = @user.company

    mail(to: "support@scheduleless.com", subject: "Customer Lead: #{@company.name}")
  end
end
