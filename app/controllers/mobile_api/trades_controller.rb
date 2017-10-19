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
      @trades = Trades::Finder.new(user: current_user).available

      render json: {
        trades: MobileApi::TradesPresenter.for(@trades)
      }, status: :ok
    end

    private

    def shift
      @_shift ||= Shifts::Finder.for(current_user).find_by(id: params[:shift_id])
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
