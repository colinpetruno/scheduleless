class MyTradesController < AuthenticatedController
  def show
    authorize :my_trade

    @trades = Trades::Finder.new(user: current_user).created
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
