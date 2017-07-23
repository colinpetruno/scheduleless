class NewCalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?
    @location = current_company.locations.find(params[:location_id])

    @presenter = NewCalendar::ShowPresenter.new(date: date,
                                                location: @location,
                                                user: current_user)
  end

  private

  def date
    Date.parse(params[:date])
  rescue
    nil
  end
end
