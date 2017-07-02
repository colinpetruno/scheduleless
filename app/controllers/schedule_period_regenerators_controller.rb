class SchedulePeriodRegeneratorsController < AuthenticatedController
  def create
    @scheduling_period = current_company.
      scheduling_periods.find(params[:scheduling_period_id])
    @location = @scheduling_period.location # for auth location context

    authorize @scheduling_period

    SchedulePeriodRegenerator.for(@scheduling_period, false).regenerate

    redirect_to locations_location_scheduling_period_path(
      @location,
      @scheduling_period
    )
  end
end
