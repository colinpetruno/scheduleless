class LocationsController < AuthenticatedController
  def index
    @locations = current_company.locations
  end

  def new
  end
end
