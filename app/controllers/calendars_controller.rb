class CalendarsController < AuthenticatedController
  include StatefulParams

  def show
    authorize :calendar, :show?
    @location = current_company.locations.find(params[:location_id])

    @presenter = Calendar::ShowPresenter.new(date: date,
                                             location: @location,
                                             user: current_user,
                                             mode: mode,
                                             view: view)
  end

  private

  def date
    Date.parse(params[:date])
  rescue
    nil
  end
end
