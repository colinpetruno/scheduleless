module Shifts
  module Finders
    class ByWeek
      def initialize(date: Date.today, in_progress: false, location:)
        @date = date
        @in_progress = in_progress
        @location = location

        # ensure repeating shifts get populated during this range
        Shifts::RepeatingShiftsPopulator.
          new(end_date: dates.end_of_week,
              location: location,
              start_date: dates.beginning_of_week).
          populate
      end

      def all
        shifts
      end

      def for_date(date)
        date_map[date.to_s(:integer)] || []
      end

      def for_user_on_date(user, date)
        user_date_map["#{user.id}-#{date.to_s(:integer)}"] || []
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
          includes(:user, :position).
          order(:date, :minute_start)
      end

      def in_progress?
        in_progress
      end

      def past_shifts
        @_past_shifts ||= location.
          shifts.
          where("date < ?", current_location_date).
          includes(:in_progress_shift, :user, :position).
          order(:date, :minute_start)
      end

      def shifts
        @_raw_shifts ||= future_shifts + past_shifts
      end

      def dates
        @_week_dates ||= DateAndTime::WeekDates.for(date)
      end

      def date_map
        @_date_map ||= shifts.inject({}) do |hash, shift|
          key = "#{shift.date}" # this needs to be a string
          hash[key] = [] if hash[key].blank?

          hash[key].push(shift)
          hash
        end
      end

      def user_date_map
        @_user_date_map ||= shifts.inject({}) do |hash, shift|
          key = "#{shift.user_id}-#{shift.date}"
          hash[key] = [] if hash[key].blank?

          hash[key].push(shift)
          hash
        end
      end
    end
  end
end
