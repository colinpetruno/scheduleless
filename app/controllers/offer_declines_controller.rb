class OfferDeclinesController < AuthenticatedController
  def create
    @offer_decline = OfferDecline.for(offer)

    authorize @offer_decline

    if @offer_decline.decline
      redirect_to location_calendar_path(offer.trade.location_id)
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
