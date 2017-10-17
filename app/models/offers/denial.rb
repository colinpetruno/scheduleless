module Offers
  class Denial
    def self.for(offer)
      new(offer: offer)
    end

    def initialize(offer:)
      @offer = offer
    end

    def location
      offer.trade.location
    end

    def perform
      offer.update(state: :not_approved)

      Notifications::Offers::DeniedJob.perform_later(offer.id)
    end

    private

    attr_reader :offer
  end
end
