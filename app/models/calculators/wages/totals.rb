module Calculators
  module Wages
    class Totals
      def self.for(wage_hash)
        new(wage_hash)
      end

      def initialize(wage_hash)
        @wage_hash = wage_hash
      end

      def double_overtime_hours
        wage_hash[:double_overtime_hours]
      rescue
        0
      end

      def double_overtime_pay
        wage_hash[:double_overtime_pay]
      rescue
        0
      end

      def total_hours
        wage_hash[:hours]
      rescue
        0
      end

      def total_pay
        wage_hash[:total]
      rescue
        0
      end

      def overtime_hours
        wage_hash[:overtime_hours]
      rescue
        0
      end

      def overtime_pay
        wage_hash[:overtime_pay]
      rescue
        0
      end

      def regular_hours
        wage_hash[:regular_hours]
      rescue
        0
      end

      def regular_pay
        wage_hash[:regular_hour_pay]
      rescue
        0
      end

      private

      attr_reader :wage_hash
    end
  end
end
