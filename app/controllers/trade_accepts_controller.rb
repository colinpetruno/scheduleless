class TradeAcceptsController < AuthenticatedController
  def create
    authorize :trade_accept, :create?

    if TradeAccept.new(trade: trade).accept
      redirect_to location_calendar_path(trade.location_id)
    else
    end
  end

  private

  def trade
    # TODO: This is not secure enough
    @_trade ||= Trade.find_by(id: params[:trade_id])
  end
end
