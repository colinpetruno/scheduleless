class Marketing::WelcomeController < ApplicationController
  layout "marketing"

  before_action :check_signed_in_user

  def index
  end

  private

  def check_signed_in_user
    if current_user.present?
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
