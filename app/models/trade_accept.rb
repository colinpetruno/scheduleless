class TradeAccept
  def initialize(offer: nil, trade:)
    @offer = offer
    @trade = trade
  end

  def accept
    # TODO need to ensure the person who accepted this is tracked
    # need to cancel the shift and create a new shift for the new person
    Trade.update(status: Trade.statuses[:completed])
  end

  private

  attr_reader :offer, :trade
end
