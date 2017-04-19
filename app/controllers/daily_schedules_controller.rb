class DailySchedulesController < AuthenticatedController
  def show
    location = current_company.locations.find(params[:location_id])
    schedule = DailySchedule.new(location: location)

    authorize schedule

    @presenter = CalendarShowPresenter.new(user: current_user, date: date)
  end

  private

  def date
    Date.parse(params[:date]) || Date.today
  end
end
