module MobileApi
  class OfferAcceptsController < ApiAuthenticatedController
    def create
      @offer_accept = Offers::Accept.for(offer)

      authorize @offer_accept

      if @offer_accept.accept
        render json: { offer: offer }, status: :ok
      else
        render json: { offer_accept: "false" }, status: :bad_request
      end
    end

    private

    def offer
      # TODO Ensure security
      @_offer = Offer.find(params[:offer_id])
    end
  end
end
