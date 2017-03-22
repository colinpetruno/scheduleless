class LocationsController < AuthenticatedController
  def index
    @locations = current_company.locations
  end

  def new
  end

  def show
    @location = current_company.locations.find(params[:id])
  end
end
