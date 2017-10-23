module Reporting
  class TimeSheetPresenter
    include ActionView::Helpers::NumberHelper

    attr_reader :company, :date, :location

    def initialize(company:, date: Date.today, location:, locations: [])
      @company = company
      @date = date
      @location = location
      @locations = locations
    end

    def employees
      @_employees ||= location.users
    end

    def graph_labels
      period.labels
    end

    def location_options
      @locations - [location]
    end

    def total_scheduled_hours
      number_with_precision(wages.for_full_week.total_hours,
                            precision: 2,
                            strip_insignificant_zeros: true)
    end

    def total_hours_worked
      hours.total_hours
    end

    def total_scheduled_wages
      Currency::FromNumber.for(wages.for_full_week.total_pay)
    end

    def hours_for_user(user)
      hours.for_employee(user)
    end

    def next_link
      routes.reporting_location_time_sheet_path(location, date: date + 7.days)
    end

    def title
      week = DateAndTime::WeekDates.new(date: date,
                                        start_day: company.schedule_start)
      beginning = week.beginning_of_week.to_s(:full_day_and_month)
      end_of_week = week.end_of_week.to_s(:full_day_and_month)

      "#{beginning} - #{end_of_week}"
    end

    def previous_link
      routes.reporting_location_time_sheet_path(location, date: date - 7.days)
    end

    def wages_for_user(user)
      wages.for_user(user)
    end

    def week_graph_values
      wages.hours_by_day_array
    end

    private

    def period
      @_period ||= SchedulePeriod.new(company: company, date: date)
    end

    def hours
      @_hours ||= Calculators::Hours::WeeklyForLocation.new(location: location,
                                                            date: date)
    end

    def routes
      Rails.application.routes.url_helpers
    end

    def wages
      @_wages ||= Calculators::Wages::WeeklyForLocation.new(location: location,
                                                            date: date)
    end
  end
end
