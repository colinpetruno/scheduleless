module Calculators
  module Wages
    class DailyForLocation
      def initialize(location:, date: Date.today, shifts: nil, published: true)
        @date = date
        @location = location
        @shifts = shifts
        @published = published
      end

      def calculate
        if totals_per_shift.present?
          @_weekly_sum ||= totals_per_shift.inject do |hash, el|
            hash.merge( el ) do |k, old_v, new_v|
              old_v + new_v
            end
          end
        else
          {
            hours: 0,
            regular_hours: 0,
            overtime_hours: 0,
            double_overtime_hours: 0,
            regular_hour_pay: 0,
            overtime_pay: 0,
            double_overtime_pay: 0,
            total: 0
          }
        end
      end

      private

      attr_reader :location, :date, :published

      def company
        @_company ||= location.company
      end

      def find_shifts
        shift_class.
          where(location_id: location.id, date: date.to_s(:integer)).
          includes(:user)
      end

      def shifts
        @shifts ||= find_shifts
      end

      def totals_per_shift
        @_totals_per_shift ||= shifts.map do |shift|
          Calculators::Wages::Shift.
            new(shift: shift,
                company: company,
                location: location,
                position: position_by_id(shift.position_id),
                user: shift.user).
            calculate
        end
      end

      def position_by_id(id)
        # memoize the positions in memory to avoid n+1
        positions.select { |p| p.id == id }.first
      end

      def positions
        @_positions ||= company.positions
      end

      def shift_class
        if published
          ::Shift
        else
          ::InProgressShift
        end
      end
    end
  end
end
