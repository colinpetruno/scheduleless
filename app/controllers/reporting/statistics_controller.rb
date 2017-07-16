module Reporting
  class StatisticsController < AuthenticatedController
    layout "reporting"

    def show
      @location = current_company.locations.find(params[:location_id])
      @date_start = params[:reporting_reporting_params] ? Date.parse(reporting_params[:date_start]) : Date.today
      @date_end = params[:reporting_reporting_params] ?  Date.parse(reporting_params[:date_end]) : @date_start + 2.weeks
      @reporting_params = Reporting::ReportingParams.new(location: @location, date_start: @date_start, date_end: @date_end)

      @hours_count_by_employee_data = hours_count_by_employee_data
      @hours_worked_over_time_data = hours_worked_over_time_data

      authorize @location
    end

    def hours_count_by_employee_data
      @_hours_count_by_employee_data ||= Reporting::HoursCountByEmployee.for(@location, @date_start, @date_end)
    end

    def hours_worked_over_time_data
      @_hours_worked_over_time_data ||= Reporting::HoursWorkedOverTime.for(@location, @date_start, @date_end)
    end

    private

    def reporting_params
      params.require(:reporting_reporting_params).permit(:date_start, :date_end)
    end
  end
end
