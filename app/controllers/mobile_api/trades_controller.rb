module MobileApi
  class TradesController < ApiAuthenticatedController
    def create
      @trade = shift.build_trade(trade_params)

      authorize @trade

      if @trade.save
        render json: { trade: @trade }, status: :ok
      else
        render json: { errors: @trade.errors }, status: :bad_request
      end
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
          user_id: current_user.id
        })
    end
  end
end
