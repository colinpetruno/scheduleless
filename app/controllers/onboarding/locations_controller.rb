class Onboarding::LocationsController < AuthenticatedController
  layout "onboarding"

  def index
    @locations = policy_scope(Location)
  end

  def edit
    @location = current_company.locations.find(params[:id])
    authorize @location
  end

  def new
    # TODO: NOTICE APPEARING ON ADD EMPLOYEE SCREEN
    @location = Location.new

    authorize @location
  end

  def create
    @location = current_user.locations.build(location_params)

    authorize @location

    if current_user.save
      redirect_to new_onboarding_position_path # new_onboarding_location_user_path(@location)
    else
      render :new
    end
  end

  def update
    @location = current_company.locations.find(params[:id])
    authorize @location

    if @location.update(location_params)
      redirect_to new_onboarding_position_path
    else
      render :edit
    end
  end

  private

  def location_params
    params.
      require(:location).
      permit(:additional_details, :city, :county_province,
             :line_1, :line_2, :line_3, :name, :postalcode, :time_zone).
      merge(company: current_company)
  end
end
