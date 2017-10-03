class OffersController < AuthenticatedController
  def create
    offer_creater = Offers::Creator.new(current_company, trade, offer_params)

    authorize offer_creater.offer

    if offer_creater.save
      redirect_to trades_path
    else
      @offer = offer_creator.offer
      render :new
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
      permit(:note, :offered_shift_id).
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
