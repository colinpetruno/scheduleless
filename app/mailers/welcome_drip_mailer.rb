class WelcomeDripMailer < ApplicationMailer
  layout "marketing_mailer"

  default from: "support@scheduleless.com",
          reply_to: "support@scheduleless.com"

  def welcome(user)
    @user = user
    # sent immediately after signing up

    mail(to: @user.email)
  end
end
