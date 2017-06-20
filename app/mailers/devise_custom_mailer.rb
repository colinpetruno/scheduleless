class DeviseCustomMailer < Devise::Mailer
  default from: "support@scheduleless.com"
  layout "mailer"
end
