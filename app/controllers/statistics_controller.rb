class StatisticsController < AuthenticatedController

  def show
    @location = current_company.locations.find(params[:location_id])
    @date_start = params[:reporting_reporting_params] ? Date.parse(reporting_params[:date_start]) : Date.today
    @date_end = params[:reporting_reporting_params] ?  Date.parse(reporting_params[:date_end]) : @date_start + 2.weeks
    @reporting_params = Reporting::ReportingParams.for(@location, @date_start, @date_end)

    @presenter = StatisticsShowPresenter.new(@reporting_params)

    authorize @location
  end

  private

  def reporting_params
    params.require(:reporting_reporting_params).permit(:date_start, :date_end)
  end
end
