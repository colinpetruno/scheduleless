class StatisticsShowPresenter
  def initialize(reporting_params)
    @reporting_params = reporting_params
  end

  def hours_count_by_employee_data
    Reporting::HoursCountByEmployee.for(@reporting_params.location, @reporting_params.date_start, @reporting_params.date_end)
  end

  def hours_worked_over_time_data
    Reporting::HoursWorkedOverTime.for(@reporting_params.location, @reporting_params.date_start, @reporting_params.date_end)
  end
end
