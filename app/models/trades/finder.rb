module Trades
  class Finder
    def initialize(user:)
      @user = user
    end

    def available
      Trade.
        joins(:shift).
        where(location_id: user_location_ids,
              status: :available,
             ).
        where.not(user_id: user.id).
        includes(:location, :user)
    end

    def available_with_limit(limit=5)
      available.first(limit)
    end

    def created
      base_trades = user.trades.includes(:offers, :shift)

      base_trades.
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

    def for_dashboard
      excluded_trade_ids = Offer.where(user_id: user.id).pluck(:trade_id)
      available.where.not(id: excluded_trade_ids).first(5)
    end

    private

    attr_reader :user

    def location_date
      DateAndTime::LocationTime.
        new(location: user.locations.first).
        current_date_integer
    end

    def location_time_minutes
      DateAndTime::LocationTime.
        new(location: user.locations.first).
        current_time_minutes
    end

    def user_location_ids
      user.user_locations.pluck(:location_id)
    end
  end
end
