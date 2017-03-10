class UsersController < AuthenticatedController

  def edit
  end

  def update
    current_user.update_attributes(user_params)
    redirect_to calendar_path
  end

  private

  def user_params
    params.
      require(:user).
      permit(:email, :family_name, :given_name, :mobile_phone, :preferred_name)
  end
end