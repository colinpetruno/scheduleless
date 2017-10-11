module Calculators
  module Wages
    class Shift
      def self.for(shift)
        new(shift: shift)
      end

      def initialize(shift:, company: nil, location: nil, user: nil, position: nil)
        @company = company
        @location = location
        @position = position
        @shift = shift
        @user = user
      end

      def calculate
        ::Calculators::Wages::Shifts::Processors::Lookup.
          for(location).
          new(company: company, shift: shift, location: location, rate: hourly_rate).
          process
      end

      private

      attr_reader :shift

      def hourly_rate
        Users::Wage.for(user: user, company: company, position: position)
      end

      def company
        @company ||= shift.company
      end

      def location
        @location ||= shift.location
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
