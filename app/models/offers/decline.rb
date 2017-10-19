module Offers
  class Decline
    attr_reader :offer

    def self.for(offer)
      new(offer: offer)
    end

    def initialize(offer:)
      @offer = offer
    end

    def decline
      offer.update(state: :declined)

      Notifications::Offers::DeclinedJob.perform_later(offer.id)
    end
  end
end
