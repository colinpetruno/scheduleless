class TradesController < AuthenticatedController
  def create
    @trade = shift.build_trade(trade_params)

    authorize @trade

    if @trade.save
      redirect_to trade_offers_path(@trade)
    else
      # TODO: Handle error
    end
  end

  def index
    @trades = policy_scope Trade.where(location_id: params[:location_id])
  end

  def new
    authorize Trade

    @trade = shift.build_trade
  end

  private

  def shift
    @_shift ||= ShiftFinder.for(current_user).find_by(id: params[:shift_id])
  end

  def trade_params
    params.
      require(:trade).
      permit(:accept_offers, :note).
      merge({
        location_id: shift.location.id,
        user_id: current_user.id
      })
  end
end
