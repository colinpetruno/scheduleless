module Calculators
  module Wages
    class WeeklyForLocation
      def initialize(location:, date: Date.today, published: true)
        @date = date
        @location = location
        @published = published
      end

      def for_full_week
        @_for_full_week ||= Totals.for(weekly_sum)
      end

      def for_date(lookup_date)
        Totals.for(wages_by_date[lookup_date.to_s(:integer)])
      end

      def for_user(user)
        Totals.for(wages_by_user[user.id])
      end

      def hours_by_day_array
        wages_by_date.values.map { |o| o[:hours] }
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

      private

      attr_reader :date, :location, :published

      def wages_by_date
        @_wages_by_date ||= schedule_period.date_range.inject({}) do |hash, lookup_date|
          hash[lookup_date.to_s(:integer)] = Calculators::Wages::DailyForLocation.
            new(location: location,
                date: lookup_date,
                published: published,
                shifts: shifts_on(lookup_date)).
            calculate

          hash
        end
      end

      def wages_by_user
        @_wages_by_user ||= users.inject({}) do |hash, user|
          hash[user.id] = Calculators::Wages::WeeklyForUser.
            new(date: date,
                published: published,
                shifts: shifts_for(user),
                user: user).
            calculate

          hash
        end
      end

      def shifts_on(lookup_date)
        shifts.select { |shift| shift.date.to_s == lookup_date.to_s(:integer) }
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

      def shifts_for(user)
        shifts.select { |shift| shift.user_id == user.id }
      end

      def shifts
        # use shift finder here
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
