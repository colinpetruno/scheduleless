module MobileApi
  class OfferDeclinesController < ApiAuthenticatedController
    def create
      @offer_decline = OfferDecline.for(offer)

      authorize @offer_decline

      if @offer_decline.decline
        # TODO: add more stuff?
        render json: { offer_decline: true }, status: :ok
      else
        render json: { offer_decline: false }, status: :bad_request
      end

    end

    private

    def offer
      # TODO Ensure security
      @_offer = Offer.find(params[:offer_id])
    end
  end
end
