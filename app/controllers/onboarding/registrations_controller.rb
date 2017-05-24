class Onboarding::RegistrationsController < ApplicationController
  layout "onboarding"

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)

    if @registration.register
      sign_in(@registration.user)
      redirect_to new_onboarding_position_path
    else
      render :new
    end
  end

  private

  def registration_params
    params.
      require(:registration).
      permit(
        :company_name,
        :email,
        :password,
        :password_confirmation,
      )
  end
end
