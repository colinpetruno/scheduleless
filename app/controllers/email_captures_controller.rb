class EmailCapturesController < ApplicationController
  layout "marketing"

  def create
    email_capture = EmailCapture.new(email_capture_params)
    email_capture.save # don't care if this is invalid

    redirect_to thanks_email_captures_path
  rescue StandardError => error
    Bugsnag.notify(error)
    redirect_to root_path
  end

  private

  def email_capture_params
    params.require(:email_capture).permit(:email)
  end
end
