module Calculators
  module Hours
    class LengthForCheckIn
      def initialize(check_in:, location: nil, start_date: nil)
        @check_in = check_in
        @location = location
        @start_date = start_date
      end

      def calculate
        if carry_over_from_previous_day?
          return 0 if location_time.to_s(:day_integer).to_i == check_in.check_in_date

          # return time that took place in that day
          check_in.check_out - check_in.check_out.beginning_of_day
        else
          duration_seconds
        end
      end

      private

      attr_reader :check_in, :start_date

      def carry_over_from_previous_day?
        start_date.present? && (check_in.check_in_date.to_i < start_date.to_s(:integer).to_i)
      end

      def check_out_time
        check_in.check_out || DateTime.now
      end

      def duration_seconds
        (check_in.check_out || DateTime.now) - check_in.check_in
      end

      def location
        @location ||= Location.find(check_in.location_id)
      end

      def location_time
        @_location_time ||= DateAndTime::LocationTime.
          new(location: location).
          for(check_out_time)
      end
    end
  end
end
