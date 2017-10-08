module Onboarding
  class RegistrationsController < ApplicationController
    layout "onboarding"

    before_action :redirect_if_logged_in?

    def new
      @registration = Registration.new(new_registration_params)
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

    def new_registration_params
      {
        email: params[:email],
        plan_id: selected_plan_id
      }
    end

    def selected_plan_id
      begin
        Plan.where("lower(plan_name) = ?", params[:tier].downcase).first.id
      rescue
        Plan.find_by(default: true).id
      end
    rescue
      nil
    end

    def registration_params
      params.
        require(:registration).
        permit(
          :email,
          :first_name,
          :last_name,
          :password,
          :password_confirmation,
          :plan_id
        )
    end
  end
end
