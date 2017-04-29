class OfferAccept
  attr_reader :offer

  def self.for(offer)
    new(offer: offer)
  end

  def initialize(offer:)
    @offer = offer
  end

  def accept
    # TODO: do stuff
    true
  end
end
