module MobileApi
  class TradesController < ApiAuthenticatedController
    def create
      @trade = shift.build_trade(trade_params)

      authorize @trade

      if @trade.save
        render json: {
          trade: MobileApi::TradePresenter.for(@trade)
        }, status: :ok
      else
        render json: { errors: @trade.errors }, status: :bad_request
      end
    end

    def index
      @trades = TradeFinder.for(current_user).find

      render json: {
        trades: MobileApi::TradesPresenter.for(@trades)
      }, status: :ok
    end

    private

    def shift
      @_shift ||= ShiftFinder.for(current_user).find_by(id: params[:shift_id])
    end

    def trade_params
      params.
        require(:trade).
        permit(:accept_offers, :note).
        merge({
          location_id: shift.location.id,
          shift_id: shift.id,
          user_id: current_user.id
        })
    end
  end
end
