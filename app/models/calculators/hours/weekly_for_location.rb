module Calculators
  module Hours
    class WeeklyForLocation
      include ActionView::Helpers::NumberHelper

      def initialize(location:, date: Date.today)
        @date = date
        @location = location
      end

      def for_employee(employee)
        format((employee_totals[employee.id] || 0).to_f / 3600)
      rescue StandardError => error
        Bugsnag.notify(error)
        0
      end

      def total_hours
        # this is currently in seconds
        format((employee_totals.values.sum.to_f || 0) / 3600)
      rescue StandardError => error
        Bugsnag.notify(error)
        0
      end

      private

      attr_reader :date, :location

      def employee_totals
        @_employee_totals ||= check_ins.inject({}) do |hash, check_in|
          hash[check_in.user_id] = 0 if hash[check_in.user_id].blank?

          hash[check_in.user_id] += LengthForCheckIn.
            new(check_in: check_in, start_date: schedule_period.start_date).
            calculate

          hash
        end
      end

      def check_ins
        @_check_ins ||= CheckIn.
          where(location_id: location.id,
                check_in_date: date_range_integers)
      end

      def date_range_integers
        # need to include the day before to catch overnight shifts from the
        # previous day
        start_date = (schedule_period.start_date - 1.day).to_s(:integer).to_i
        end_date = (schedule_period.end_date).to_s(:integer).to_i

        (start_date..end_date)
      end

      def format(number)
        number_with_precision(number,
                              precision: 2,
                              strip_insignificant_zeros: true)
      end

      def schedule_period
        @_schedule_period ||= SchedulePeriod.new(company: location.company, date: date)
      end
    end
  end
end
