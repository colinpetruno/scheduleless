class MyTradesController < AuthenticatedController
  def show
    authorize :my_trade

    base_trades = current_user.trades.includes(:offers, :shift)
    @trades = base_trades.
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
      ).available
  end

  private

  def location_date
    DateAndTime::LocationTime.
      new(location: current_user.locations.first).
      current_date_integer
  end

  def location_time_minutes
    DateAndTime::LocationTime.
      new(location: current_user.locations.first).
      current_time_minutes
  end
end
