class EmailCapturesController < ApplicationController
  def create
    email_capture = EmailCapture.new(email_capture_params)
    email_capture.save # don't care if this is invalid

    redirect_to new_onboarding_registration_path(email: email_capture.email)
  rescue StandardError => error
    Bugsnag.notify(error)
    redirect_to new_onboarding_registration_path
  end

  private

  def email_capture_params
    params.require(:email_capture).permit(:email)
  end
end
