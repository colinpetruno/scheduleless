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
