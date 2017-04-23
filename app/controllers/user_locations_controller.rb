class UserLocationsController < AuthenticatedController
  def create
    authorize UserLocation

    @user_location = location.user_locations.create(user_location_params)
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
