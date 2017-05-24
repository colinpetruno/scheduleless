class UsersController < AuthenticatedController
  def create
    @location = location

    authorize User # TODO: add location auth here

    employee_inviter = EmployeeInviter.
      new(location: location, user_params: user_params)

    if employee_inviter.send
      redirect_to location_path(location)
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
    @location = location
    @user = current_company.users.build
    authorize @user
  end

  def update
    authorize current_user

    current_user.update(user_params)

    redirect_to edit_user_path
  end

  private

  def location
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