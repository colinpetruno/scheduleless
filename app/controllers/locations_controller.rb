class LocationsController < AuthenticatedController
  def create
    @location = current_company.locations.build(location_params)

    if @location.save
      redirect_to locations_path
    else
      render :new
    end
  end

  def edit
    @locations = current_company.locations.find(params[:id])
  end

  def index
    @locations = current_company.locations
  end

  def new
    @location = current_company.locations.build
  end

  def show
    @location = current_company.locations.find(params[:id])
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
