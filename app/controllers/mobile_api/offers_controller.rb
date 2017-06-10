module MobileApi
  class OffersController < ApiAuthenticatedController

    def index
      @offers = policy_scope(Offer.where(trade_id: params[:trade_id]))

      render json: { offers: @offers }
    end

    def create
      @offer = trade.offers.build(offer_params)

      authorize @offer

      if @offer.save
        render json: { offer: @offer }, status: :ok
      else
        render json: { errors: @offer.errors }, status: :bad_request
      end
    end

    private

    def offer_params
      params.
        require(:offer).
        permit(:note, :offered_shift_id).
        merge({ company_id: current_company.id })
    end

    def trade
      # TODO: auth this better
      @_trade = Trade.find(params[:trade_id])
    end
  end
end
