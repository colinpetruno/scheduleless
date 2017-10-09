module Onboarding
  class UsersController < BaseController
    layout "onboarding"

    def destroy
      @location = current_company.locations.find(params[:location_id])
      @user = @location.users.find(params[:id])

      authorize @user

      if EmployeeRemover.for(@user).remove
        redirect_to onboarding_location_users_path
      else
        redirect_to onboarding_location_users_path,
          alert: "Something went wrong deleting this employee"
      end
    end

    def index
      skip_policy_scope
      @location = current_company.locations.find(params[:location_id])

      @users = @location.users - [current_user]
    end

    def new
      @location = current_company.locations.find(params[:location_id])
      @employee_creator = Onboarding::EmployeeCreator.new # User.new

      authorize User
    end

    def create
      @location = current_company.locations.find(params[:location_id])
      authorize User

      @employee_creator = Onboarding::EmployeeCreator.new(user_params.merge(default_params))

      if @employee_creator.valid? && @employee_creator.create
        Onboarding::Status.for(current_company).move_to_next_step!(6)
        redirect_to new_onboarding_location_user_path(@location),
          notice: I18n.t("onboarding.users.controller.created_success")
      else
        render :new
      end
    end

    private

    def default_params
      { locations: [@location], company: current_company }
    end

    def user_params
      params.
        require(:user).
        permit(:email,
               :family_name,
               :given_name,
               :mobile_phone,
               :preferred_name,
               :primary_position_id,
               :salary,
               :wage,
               position_ids: []
              )
    end
  end
end
