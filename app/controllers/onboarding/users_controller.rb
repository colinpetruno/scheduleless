class Onboarding::UsersController < AuthenticatedController
  layout "onboarding"

  def index
    skip_policy_scope
    @location = current_company.locations.find(params[:location_id])

    @users = @location.users - [current_user]
  end

  def new
    @location = current_company.locations.find(params[:location_id])
    @user = User.new

    authorize @user
  end

  def create
    @location = current_company.locations.find(params[:location_id])
    authorize User

    @user = User.invite!(user_params.merge(default_params)) do |user|
      user.skip_invitation = true
    end

    if @user.persisted?
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
             position_ids: []
            )
  end
end
