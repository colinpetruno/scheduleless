module MobileApi
  class MyTradesController < ApiAuthenticatedController
    def show
      @my_trades = current_user.trades

      # TODO: auth this better
      render json: { my_trades: @my_trades }, status: :ok
    end
  end
end
