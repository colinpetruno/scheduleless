module Calculators
  module Hours
    class WeeklyForLocation
      def initialize(location:, date: Date.today)
        @date = date
        @location = location
      end

      private

      attr_reader :date, :location

      def check_ins
        @_check_ins ||= CheckIn.
          where(location_id: location.id,
                check_in_date_time: (1..2))
      end
    end
  end
end
