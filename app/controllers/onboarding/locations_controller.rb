class Onboarding::LocationsController < AuthenticatedController
  layout "onboarding"

  def new
    @location = Location.new

    authorize @location
  end

  def create
    location = current_user.locations.build(location_params)

    authorize location

    if current_user.save
      redirect_to new_onboarding_location_user_path(location)
    end
  end

  private

  def location_params
    params.
      require(:location).
      permit(:additional_details, :city, :county_province,
             :line_1, :line_2, :line_3, :postalcode, :time_zone).
      merge(company: current_company)
  end
end
