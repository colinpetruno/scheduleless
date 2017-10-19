module MobileApi
  class MyTradesController < ApiAuthenticatedController
    def show
      @my_trades = Trades::Finder.new(user: current_user).created

      # TODO: auth this better
      render json: {
        my_trades: MobileApi::TradesPresenter.for(@my_trades)
      }, status: :ok
    end
  end
end
