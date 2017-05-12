class TradeAcceptsController < AuthenticatedController
  def create
    authorize :trade_accept, :create?

    if TradeAccept.new(trade: trade, offer: offer, user: current_user).accept
      redirect_to trades_path
    else
    end
  end

  private

  def offer
    @_offer ||=
      if params[:offer_id]
        Offer.find_by(id: params[:offer_id])
      else
        nil
      end
  end

  def trade
    # TODO: This is not secure enough
    @_trade ||= Trade.find_by(id: params[:trade_id])
  end
end
