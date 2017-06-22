class UsersController < AuthenticatedController
  def create
    @location = find_location

    authorize User # TODO: add location auth here

    employee_inviter = EmployeeInviter.
      new(location: @location, user_params: user_params)

    if employee_inviter.send
      redirect_to location_path(@location)
    else
      @user = employee_inviter.user
      render :new
    end
  end

  def edit
    @user = current_user
    authorize @user
  end

  def new
    @location = find_location
    @user = current_company.users.build
    authorize @user
  end

  def update
    authorize current_user
    if current_user.update(user_params)
      redirect_to edit_user_path
    else
      render :edit
    end
  end

  private

  # note location is a rails method that will screw up the redirect if used
  def find_location
    current_company.locations.find(params[:location_id])
  end

  def user_params
    params.
      require(:user).
      permit(:email,
             :family_name,
             :given_name,
             :mobile_phone,
             :preferred_name,
             preferred_hours_attributes: [:id, :start, :end]
            ).
      merge(company_id: current_company.id)
  end
end