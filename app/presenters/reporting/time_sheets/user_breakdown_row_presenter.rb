module Reporting
  module TimeSheets
    class UserBreakdownRowPresenter
      include ActionView::Helpers::NumberHelper

      def initialize(employee:, hours:, wages:)
        @employee = employee
        @hours = hours
        @wages = wages
      end

      def estimated_scheduled_pay
        Currency::FromNumber.for(wages.total_pay)
      end

      def name
        employee.full_name
      end

      def scheduled_overtime_hours
        format(wages.overtime_hours.to_i + wages.double_overtime_hours.to_i)
      end

      def scheduled_regular_hours
        wages.regular_hours
      end

      def total_scheduled_hours
        wages.total_hours
      end

      def total_worked_hours
        hours
      end

      def variance
        format(total_worked_hours.to_f - total_scheduled_hours.to_f)
      end

      def variance_classes
        # if they are off by more than 30 minutes
        if variance.to_f.abs > 0.5
          "out-of-range"
        end
      end

      def warnings
        wage = employee.wage_cents

        if (wage.blank? || wage == 0) && !employee.salary?
          '<span class="oi oi-warning" data-toggle="tooltip" title="Missing Hourly Rate"></span>'.html_safe
        end
      end

      private

      attr_reader :employee, :hours, :wages

      def format(number)
        number_with_precision(number,
                              precision: 2,
                              strip_insignificant_zeros: true)
      end
    end
  end
end
