module Calculators
  module Wages
    class WeeklyForLocation
      def initialize(location:, date: Date.today, published: true)
        @date = date
        @location = location
        @published = published
      end

      def calculate
        weekly_sum
      end

      def double_overtime_hours
        weekly_sum[:double_overtime_hours]
      rescue
        0
      end

      def double_overtime_pay
        weekly_sum[:double_overtime_pay]
      rescue
        0
      end

      def errors?
        if @_errors.present?
          @_errors
        else
          weekly_sum
          nil
        end
      rescue StandardError => error
        Bugsnag.notify(error)
        @_errors = false
      end

      def total_hours
        weekly_sum[:hours]
      rescue
        0
      end

      def total_pay
        weekly_sum[:total]
      rescue
        0
      end

      def overtime_hours
        weekly_sum[:overtime_hours]
      rescue
        0
      end

      def overtime_pay
        weekly_sum[:overtime_pay]
      rescue
        0
      end

      def regular_hours
        weekly_sum[:regular_hours]
      rescue
        0
      end

      def regular_pay
        weekly_sum[:regular_hour_pay]
      rescue
        0
      end

      def wages_by_user
        @_wages_by_user ||= build_wages_by_user_hash
      end

      private

      attr_reader :date, :location, :published

      def build_wages_by_user_hash
        users.inject({}) do |hash, user|
          hash[user.id] = Calculators::Wages::WeeklyForUser.
            new(date: date,
                published: published,
                shifts: shifts_for_(user),
                user: user).
            calculate

          hash
        end
      end

      def wages_by_user_array
        wages_by_user.values
      end

      def weekly_sum
        # combines multiple hashes into one summing all the elements
        @_weekly_sum ||= wages_by_user_array.inject do |hash, el|
          hash.merge( el ) do |k, old_v, new_v|
            old_v + new_v
          end
        end
      end

      def company
        @_company ||= location.company
      end

      def schedule_period
        @_schedule_period ||= SchedulePeriod.new(company: company,
                                                 date: date)
      end

      def shifts_for_(user)
        shifts.select { |shift| shift.user_id == user.id }
      end

      def shifts
        @_shifts ||= shift_class.
          where(date: schedule_period.date_range_integers,
                location_id: location.id)
      end

      def shift_class
        if published
          ::Shift
        else
          ::InProgressShift
        end
      end

      def users
        @_users ||= location.users
      end
    end
  end
end
