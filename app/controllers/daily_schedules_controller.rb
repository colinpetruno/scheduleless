class DailySchedulesController < AuthenticatedController
  def show
    location = current_company.locations.find(params[:location_id])
    schedule = DailySchedule.new(location: location)

    authorize schedule

    @presenter = CalendarShowPresenter.
      new(date: date, current_location: location, user: current_user)
  end

  private

  def date
    Date.parse(params[:date]) || Date.today
  end
end
