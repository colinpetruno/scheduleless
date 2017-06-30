class DailySchedulesController < AuthenticatedController
  def show
    # TODO: This may be a remote only endpoint, if so move to remotes
    location = current_company.locations.find(params[:location_id])
    schedule = DailySchedule.new(location: location)

    authorize location

    @presenter = CalendarShowPresenter.
      new(date: date, current_location: location, user: current_user, view: view)
  end

  private

  def date
    Date.parse(params[:date]) || Date.today
  end

  def view
    if params[:view].present?
      cookies[:view] = params[:view]
    end

    params[:view] || cookies[:view] ||  "day"
  end
end
