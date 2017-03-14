class UsersController < AuthenticatedController
  def edit
    @user = current_user
  end

  def update
    current_user.update(user_params)
    redirect_to edit_user_path
  end

  private

  def user_params
    params.
      require(:user).
      permit(:email, :family_name, :given_name, :mobile_phone, :preferred_name)
  end
end