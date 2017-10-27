module Calculators
  module Wages
    class WeeklyForUser
      OVERTIME_THRESHOLD = 40

      def initialize(user:, date: Date.today, location: nil, shifts: nil, published: true)
        @date = date
        @location = location
        @published = published
        @shifts = shifts
        @user = user
      end

      def calculate
        if weekly_sum[:regular_hours] > OVERTIME_THRESHOLD
          adjust_weekly_sum
        else
          weekly_sum
        end
      end

      private

      attr_reader :date, :location, :published, :user

      def adjust_weekly_sum
        # TODO: this could be sketch besides being a super ugly method it may
        # not be quite advanced enough
        #
        average_pay = weekly_sum[:regular_hour_pay].to_f / weekly_sum[:regular_hours].to_f

        overtime_hours = weekly_sum[:regular_hours] - OVERTIME_THRESHOLD
        new_overtime_hours = weekly_sum[:overtime_hours] + overtime_hours

        overtime_subtract = average_pay * overtime_hours

        extra_overtime_amount = average_pay * overtime_hours * 1.5

        regular_hours = weekly_sum[:regular_hours] - overtime_hours
        regular_hour_pay = weekly_sum[:regular_hour_pay] - overtime_subtract

        overtime_pay = weekly_sum[:overtime_pay] + extra_overtime_amount
        double_overtime_pay = weekly_sum[:double_overtime_pay]
        total = regular_hour_pay + overtime_pay + double_overtime_pay

        {
          hours: weekly_sum[:hours],
          regular_hours: regular_hours,
          overtime_hours: new_overtime_hours,
          double_overtime_hours: weekly_sum[:double_overtime_hours],
          regular_hour_pay: regular_hour_pay,
          overtime_pay: overtime_pay,
          double_overtime_pay: double_overtime_pay,
          total: total
        }
      end

      def company
        @_company ||= user.company
      end

      def schedule_period
        @_schedule_period ||= SchedulePeriod.new(company: company,
                                                 date: date)
      end

      def weekly_sum
        # combines multiple hashes into one summing all the elements
        if totals_per_shift.present?
          @_weekly_sum ||= totals_per_shift.inject do |hash, el|
            hash.merge( el ) do |k, old_v, new_v|
              old_v + new_v
            end
          end
        else
          default_hash
        end
      end

      def default_hash
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

      def totals_per_shift
        @_totals_per_shift ||= shifts.map do |shift|
          Calculators::Wages::Shift.
            new(shift: shift,
                company: company,
                location: shift.location,
                user: user).
            calculate
        end
      end

      def shifts
        @shifts ||= retrieve_shifts
      end

      def retrieve_shifts
        scope = shift_class.where(date: schedule_period.date_range_integers,
                                  user_id: user.id)

        scope = scope.where(location_id: location.id) if location.present?

        scope.includes(:location).order(:date)
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
