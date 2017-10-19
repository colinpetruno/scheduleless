module Trades
  class Finder
    def initialize(user:)
      @user = user
    end

    def available
      Trade.
        where(location_id: user_location_ids, status: :available).
        where.not(user_id: user.id).
        includes(:location, :user)
    end

    def available_with_limit(limit=5)
      available.first(limit)
    end

    def created
      user.
        trades.
        includes(:offers, :shift).
        where(
          shifts: {
            date: ((location_date+1)..Float::INFINITY)
          }
        ).or(
          base_trades.where(
            shifts: {
              date: location_date,
              minute_start: (location_time_minutes..Float::INFINITY)
            }
          )
        ).
        available
    end

    private

    attr_reader :user

    def user_location_ids
      user.user_locations.pluck(:location_id)
    end
  end
end
