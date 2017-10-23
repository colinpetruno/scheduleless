module Calculators
  module Wages
    class Totals
      include ActionView::Helpers::NumberHelper

      def self.for(wage_hash)
        new(wage_hash)
      end

      def initialize(wage_hash)
        @wage_hash = wage_hash
      end

      def double_overtime_hours
        format(wage_hash[:double_overtime_hours])
      rescue
        0
      end

      def double_overtime_pay
        format(wage_hash[:double_overtime_pay])
      rescue
        0
      end

      def total_hours
        format(wage_hash[:hours])
      rescue
        0
      end

      def total_pay
        format(wage_hash[:total])
      rescue
        0
      end

      def overtime_hours
        format(wage_hash[:overtime_hours])
      rescue
        0
      end

      def overtime_pay
        format(wage_hash[:overtime_pay])
      rescue
        0
      end

      def regular_hours
        format(wage_hash[:regular_hours])
      rescue
        0
      end

      def regular_pay
        format(wage_hash[:regular_hour_pay])
      rescue
        0
      end

      private

      attr_reader :wage_hash

      def format(number)
        number_with_precision(number,
                              precision: 2,
                              strip_insignificant_zeros: true)
      end
    end
  end
end
