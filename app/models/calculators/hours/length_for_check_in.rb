module Calculators
  module Hours
    class LengthForCheckIn
      def initialize(check_in:, start_date: nil)
        @check_in = check_in
        @start_date = start_date
      end

      def calculate
        if carry_over_from_previous_day?
          duration_seconds
        else
          duration_seconds
        end
      end

      private

      attr_reader :check_in, :start_date

      def carry_over_from_previous_day?
        start_date.present? && (check_in.check_in_date.to_i < start_date.to_s(:integer).to_i)
      end

      def duration_seconds
        (check_in.check_out || DateTime.now) - check_in.check_in
      end
    end
  end
end
