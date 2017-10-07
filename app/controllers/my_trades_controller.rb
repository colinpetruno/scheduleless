class MyTradesController < AuthenticatedController
  def show
    authorize :my_trade

    @trades = current_user.trades.includes(:offers, :shift).available
  end
end
