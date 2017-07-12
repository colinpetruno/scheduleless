class Onboarding::RegistrationsController < ApplicationController
  layout "onboarding"

  before_action :redirect_if_logged_in?

  def new
    @registration = Registration.new(email: params[:email])
  end

  def create
    @registration = Registration.new(registration_params)

    if @registration.valid? && @registration.register
      sign_in(@registration.user)

      redirect_to edit_onboarding_company_path
    else
      render :new
    end
  end

  private

  def redirect_if_logged_in?
    if current_user.present?
      if current_user.leads.present?
        redirect_to new_onboarding_position_path and return
      else
        redirect_to new_onboarding_lead_path and return
      end
    end
  end

  def registration_params
    params.
      require(:registration).
      permit(
        :company_name,
        :email,
        :first_name,
        :last_name,
        :password,
        :password_confirmation,
      )
  end
end
