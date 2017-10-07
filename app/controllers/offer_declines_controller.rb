class OfferDeclinesController < AuthenticatedController
  def create
    @offer_decline = Offers::Decline.for(offer)

    authorize @offer_decline

    if @offer_decline.decline
      redirect_to trade_offers_path(offer.trade)
    else
      # TODO: fix error
    end

  end

  private

  def offer
    # TODO Ensure security
    @_offer = Offer.find(params[:offer_id])
  end
end
