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
    if params[:view].present?
      cookies[:view] = params[:view]
    end

    params[:view] || cookies[:view] ||  "daily"
  end

  def date
    Date.parse(params[:date])
  rescue
    nil
  end
end
