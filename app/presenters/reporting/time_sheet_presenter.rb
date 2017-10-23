module Reporting
  class TimeSheetPresenter
    include ActionView::Helpers::NumberHelper

    attr_reader :company, :date, :location

    def initialize(company:, date: Date.today, location:)
      @company = company
      @date = date
      @location = location
    end

    def employees
      @_employees ||= location.users
    end

    def total_scheduled_hours
      number_with_precision(wages.for_full_week.total_hours,
                            precision: 2,
                            strip_insignificant_zeros: true)
    end

    def total_scheduled_wages
      Currency::FromNumber.for(wages.for_full_week.total_pay)
    end

    def wages_for_user(user)
      wages.for_user(user)
    end

    def warnings_for(employee)
      wage = employee.wage_cents

      if (wage.blank? || wage == 0) && !employee.salary?
        '<span class="oi oi-warning" data-toggle="tooltip" title="Missing Hourly Rate"></span>'.html_safe
      end
    end

    def week_graph_values
      wages.hours_by_day_array
    end

    private

    def period
      @_period ||= SchedulePeriod.new(company: company, date: date)
    end

    def wages
      @_wages ||= Calculators::Wages::WeeklyForLocation.new(location: location,
                                                            date: date)
    end
  end
end
