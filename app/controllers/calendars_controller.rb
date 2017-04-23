class CalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?

    location = current_company.locations.find(params[:location_id])

    @presenter = CalendarShowPresenter.
      new(date: date, current_location: location, user: current_user)
  end

  private

  def date
    Date.parse(params[:date]) || Date.today
  rescue
    Date.today
  end
end
