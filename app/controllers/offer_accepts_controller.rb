class OfferAcceptsController < AuthenticatedController
  def create
    @offer_accept = OfferAccept.for(offer)

    authorize @offer_accept

    if @offer_accept.accept
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
