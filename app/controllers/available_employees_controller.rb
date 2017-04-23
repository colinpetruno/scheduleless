class AvailableEmployeesController < AuthenticatedController
  after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    authorize AvailableEmployees

    render json: AvailableEmployees.
      new(location: location, query: query).
      retrieve
  end

  private

  def location
    current_company.locations.find(params[:location_id])
  end

  def query
    params[:query]
  end
end
