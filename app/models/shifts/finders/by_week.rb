module Shifts
  module Finders
    class ByWeek
      def initialize(date: Date.today, in_progress: false, location:)
        @date = date
        @in_progress = in_progress
        @location = location
      end

      def find
        Shifts::RepeatingShiftsPopulator.
          new(end_date: dates.end_of_week,
              location: location,
              start_date: dates.beginning_of_week).
          populate

        shifts
      end

      private

      attr_reader :date, :in_progress, :location

      def base_scope
        if in_progress == true
          location.in_progress_shifts
        else
          location.shifts
        end
      end

      def current_location_date
        DateAndTime::LocationTime.new(location: location).current_date_integer
      end

      def date_range_integers
        (dates.beginning_of_week(:integer)..dates.end_of_week(:integer))
      end

      def future_shifts
        @_future_shifts ||= base_scope.
          where(date: date_range_integers).
          where("date >= ?", current_location_date).
          includes(:user).
          order(:date, :minute_start)
      end

      def in_progress?
        in_progress
      end

      def past_shifts
        @_past_shifts ||= location.
          shifts.
          where("date < ?", current_location_date).
          includes(:user).
          order(:date, :minute_start)
      end

      def shifts
        @_raw_shifts ||= future_shifts + past_shifts
      end

      def dates
        @_week_dates ||= DateAndTime::WeekDates.for(date)
      end
    end
  end
end
