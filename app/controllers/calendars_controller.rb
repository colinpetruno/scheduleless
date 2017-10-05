class CalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?
    @location = current_company.locations.find(params[:location_id])

    @presenter = Calendar::ShowPresenter.new(date: date,
                                                location: @location,
                                                user: current_user,
                                                view: view)
  end

  private

  def view
    cookies[:view] = params[:view] || cookies[:view] ||  "weekly"

    cookies[:view]
  end

  def date
    Date.parse(params[:date])
  rescue
    nil
  end
end
