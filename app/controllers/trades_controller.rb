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
    @trades = policy_scope trade_scope
  end

  def new
    authorize Trade

    @trade = shift.build_trade
  end

  private

  def shift
    @_shift ||= Shifts::Finder.for(current_user).find_by(id: params[:shift_id])
  end

  def trade_params
    params.
      require(:trade).
      permit(:accept_offers, :note).
      merge({
        location_id: shift.location.id,
        shift_id: shift.id,
        user_id: current_user.id
      })
  end

  def trade_scope
    if params[:location_id].present?
      Trade.where(location_id: params[:location_id])
    else
      Trade
    end
  end
end
