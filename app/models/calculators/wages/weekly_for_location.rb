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
      end

      def double_overtime_pay
        weekly_sum[:double_overtime_pay]
      end

      def total_hours
        weekly_sum[:hours]
      end

      def total_pay
        weekly_sum[:total]
      end

      def overtime_hours
        weekly_sum[:overtime_hours]
      end

      def overtime_pay
        weekly_sum[:overtime_pay]
      end

      def regular_hours
        weekly_sum[:regular_hours]
      end

      def regular_pay
        weekly_sum[:regular_hour_pay]
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

      def users
        @_users ||= location.users
      end
    end
  end
end
