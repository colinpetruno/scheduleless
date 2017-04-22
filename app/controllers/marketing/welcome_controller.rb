class Marketing::WelcomeController < ApplicationController
  layout "marketing"

  before_filter :check_signed_in_user

  def index
  end

  private

  def check_signed_in_user
    if current_user.present?
      redirect_to calendar_path and return
    end
  end
end
