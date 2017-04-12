class LocationsController < AuthenticatedController
  def create
    @location = current_company.locations.build(location_params)

    authorize @location

    if @location.save
      redirect_to locations_path
    else
      render :new
    end
  end

  def edit
    @location = current_company.locations.find(params[:id])
    authorize @location
  end

  def index
    @locations = policy_scope(Location)
  end

  def new
    @location = current_company.locations.build
    authorize @location
  end

  def show
    @location = current_company.locations.find(params[:id])
    authorize @location
  end

  private

  def location_params
    params.
      require(:location).
      permit(:city,
             :county_province,
             :country,
             :line_1,
             :line_2,
             :line_3,
             :name,
             :postal_code
            )
  end
end
