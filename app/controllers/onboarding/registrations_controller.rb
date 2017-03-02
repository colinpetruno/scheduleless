class Onboarding::RegistrationsController < ApplicationController
  layout "onboarding"

  def new
    @registration = Registration.new
  end

  def create
    registration = Registration.new(registration_params)

    if registration.register
      sign_in(registration.user)
      redirect_to new_onboarding_location_path
    else
      redirect_to root_path
    end
  end

  private

  def registration_params
    params.
      require(:registration).
      permit(user_params: [
        :email,
        :password,
        :password_confirmation,
        company_attributes: [
          :name
        ]
      ])
  end
end
