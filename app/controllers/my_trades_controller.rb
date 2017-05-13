class MyTradesController < AuthenticatedController
  def show
    authorize :my_trade

    @trades = current_user.trades.available
  end
end
