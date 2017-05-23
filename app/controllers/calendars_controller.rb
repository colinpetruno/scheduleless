class CalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?

    @presenter = CalendarShowPresenter.
      new(date: date, current_location: location, user: current_user)
  end

  private

  def date
    Date.parse(params[:date]) || Date.today
  rescue
    Date.today
  end

  def location
    if params[:location_id].present?
      current_company.locations.find(params[:location_id])
    else
      nil
    end
  end
end
