class UserLocationsController < AuthenticatedController
  def create
    authorize UserLocation

    @user_location = location.user_locations.build(user_location_params)

    if @user_location.save
      redirect_to location_users_path(location)
    else
      redirect_to new_locations_location_user_path(location),
        alert: "We were unable to add this employee"
    end
  end

  private

  def location
    @location ||= current_company.locations.find(params[:location_id])
  end

  def user_location_params
    params.
      require(:user_location).
      permit(:admin, :home, :location_id, :user_id)
  end
end
