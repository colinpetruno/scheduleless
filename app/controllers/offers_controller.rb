class OffersController < AuthenticatedController
  def create
    @offer = trade.offers.build(offer_params)

    authorize @offer

    if @offer.save
      redirect_to trades_path
    else
      # TODO handle error
    end
  end

  def index
    @offers = policy_scope(Offer.where(trade_id: params[:trade_id]))
  end

  def new
    # TODO: Ensure the trade can't be seen by the person that made it...
    @offer = trade.offers.build

    authorize @offer
  end

  private

  def offer_params
    params.
      require(:offer).
      permit(:note, :offered_trade_id).
      merge({
        company_id: current_company.id,
        user_id: current_user.id
      })
  end

  def trade
    # TODO: Unsecure, scope to at least companies
    @_trade ||= Trade.find(params[:trade_id])
  end
end
