class TradeAccept
  def initialize(offer: nil, trade:, user:)
    @offer = offer
    @trade = trade
    @user = user
  end

  def accept
    if offer.blank?
      ShiftTaker.new(trade: @trade, user: user).take
    else
      ShiftTrader.new(offer: offer, trade: trade, user: user)
    end
  end

  private

  attr_reader :offer, :trade, :user
end
