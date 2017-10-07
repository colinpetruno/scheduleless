class OfferAcceptsController < AuthenticatedController
  def create
    @offer_accept = Offers::Accept.for(offer)

    authorize @offer_accept

    if @offer_accept.accept
      redirect_to my_trades_path
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
