module MobileApi
  class MyTradesController < ApiAuthenticatedController
    def show
      @my_trades = current_user.trades.available

      # TODO: auth this better
      render json: {
        my_trades: MobileApi::TradesPresenter.for(@my_trades)
      }, status: :ok
    end
  end
end
