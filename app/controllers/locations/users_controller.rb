module Locations
  class UsersController < AuthenticatedController
    def create
      @location = current_company.locations.find(params[:location_id])

      authorize User # TODO: add location auth here

      employee_inviter = EmployeeInviter.
        new(location: @location, user_params: user_params)

      if employee_inviter.send
        redirect_to locations_location_users_path(@location)
      else
        @user = employee_inviter.user
        render :new
      end
    end

    def destroy
      @location = current_company.locations.find(params[:location_id])
      @user_location = @location.user_locations.find_by(user_id: params[:id])

      authorize @user_location

      if @user_location.destroy
        redirect_to locations_location_users_path(@location)
      else
        redirect_to locations_location_users_path(@location), alert: "We could not remove this employee from this location at this time"
      end
    end

    def edit
      @location = current_company.locations.find(params[:location_id])
      @user = current_company.users.find(params[:id])
      authorize @user
    end

    def index
      skip_policy_scope # TODO: FIX ME
      @location = current_company.locations.find(params[:location_id])

      users = UserFinder.
        new(location: @location).
        by_location

      @presenter =  UserListPresenter.for(users)
    end

    def new
      @location = current_company.locations.find(params[:location_id])
      @user = current_company.users.build
      authorize @user
    end

    def update
      @user = current_company.users.find(params[:id])
      authorize @user

      if @user.update(user_params)
        redirect_to locations_location_users_path
      else
        render :edit
      end
    end

    private

    def user_params
      params.
        require(:user).
        permit(:email,
               :family_name,
               :given_name,
               :mobile_phone,
               :preferred_name,
               :primary_position_id,
               :wage,
               preferred_hours_attributes: [:id, :start, :end]
              ).
        merge(company_id: current_company.id)
    end
  end
end
