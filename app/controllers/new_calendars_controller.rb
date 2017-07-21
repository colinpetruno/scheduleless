class NewCalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?
    @location = current_company.locations.find(params[:location_id])
  end
end
