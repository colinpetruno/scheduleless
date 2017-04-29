class OffersController < AuthenticatedController
  def index
    @offers = policy_scope(Offer.where(trade_id: params[:trade_id]))
  end

  def create

  end

  private
end
