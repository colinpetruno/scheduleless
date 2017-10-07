module Remote
  module Dashboard
    module Offers
      class ApprovalsController < AuthenticatedController
        def create
          @offer = Offer.find(params[:offer_id])
          @approval = ::Offers::Approval.for(@offer)

          authorize @approval

          @approval.perform
        end
      end
    end
  end
end
