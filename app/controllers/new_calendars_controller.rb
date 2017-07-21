class NewCalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?
    @location = current_company.locations.find(params[:location_id])

    @presenter = NewCalendar::ShowPresenter.new(location: @location, user: current_user)
  end
end
