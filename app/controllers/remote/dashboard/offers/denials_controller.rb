module Remote
  module Dashboard
    module Offers
      class DenialsController < AuthenticatedController
        def create
          @offer = Offer.find(params[:offer_id])
          @denial = ::Offers::Denial.for(@offer)

          authorize @denial

          @denial.perform
        end
      end
    end
  end
end
