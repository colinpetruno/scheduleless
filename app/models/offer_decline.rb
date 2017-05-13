class OfferDecline
  attr_reader :offer

  def self.for(offer)
    new(offer: offer)
  end

  def initialize(offer:)
    @offer = offer
  end

  def decline
    offer.update(state: Offer.states[:declined])
    # TODO: send notifications
  end
end
