class SchedulingPeriodPublishersController < AuthenticatedController
  def create
    @scheduling_period = current_company.
      scheduling_periods.
      find(params[:scheduling_period_id])
    @location = @scheduling_period.location

    authorize @scheduling_period

    if SchedulingPeriodPublisher.for(@scheduling_period).publish
      redirect_to locations_location_scheduling_periods_path(@location)
    else
      redirect_to(
        locations_location_scheduling_period_path(@location, @scheduling_period),
        alert: "We could not publish your schedule right now. We are looking into it"
      )
    end
  end
end
