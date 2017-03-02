class Onboarding::UsersController < AuthenticatedController
  layout "onboarding"

  def new
    @location = Location.find(params[:location_id])
    @user = User.new
  end

  def create
    @location = current_user.locations.find(params[:location_id])

    User.invite!(user_params.merge(locations: [@location])) do |user|
      user.skip_invitation = true
    end

    if params[:add_another_user].present?
      redirect_to new_onboarding_location_user_path(@location)
    else
      redirect_to new_onboarding_schedule_path
    end
  end

  private

  def user_params
    params.
      require(:user).
      permit(:email, :family_name, :given_name, :mobile_phone, :preferred_name)
  end
end
