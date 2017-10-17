class PrintsController < AuthenticatedController
  layout "print"

  def show
    authorize :print, :show?

    @location = policy_scope(Location).find(params[:location_id])
    @date = date
  end

  private

  def date
    if params[:date].present?
      Date.parse(params[:date])
    else
      Date.today
    end
  end
end
