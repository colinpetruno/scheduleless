module Calculators
  module Wages
    class Shift
      def self.for(shift)
        new(shift: shift)
      end

      def initialize(shift:, company: nil, user: nil, position: nil)
        @shift = shift
        @company = company
        @user = user
        @position = position
      end

      def calculate
        # if user exempt
          # 0
        Shifts::Processors::Lookup.
          for(location).
          new(shift: shift, rate: 1000).
          process
      end

      private

      attr_reader :shift

      def hourly_rate
        1000
      end

      def company
        @company ||= shift.company
      end

      def location
        shift.location
      end

      def position
        @position ||= shift.position
      end

      def user
        @user ||= shift.user
      end
    end
  end
end
