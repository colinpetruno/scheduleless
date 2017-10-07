class ShiftTrader
  def initialize(offer:, trade:)
    @offer = offer
    @trade = trade
  end

  def execute
    # update shift statuses to traded
    with_transaction do
      # TODO: rewrite this to account for in_progress shifts


      for_trade_shift.update(state: Shift.states[:traded])

      if offered_shift.present?
        offered_shift.update(state: Shift.states[:traded])
      end

      offer.update(state: Offer.states[:accepted])
      trade.update(status: Trade.statuses[:completed], traded_with_id: offer.user_id)

      # NOTE: the user here is inversed since we are swapping shifts
      Shift.create(new_shift_attributes(for_trade_shift, offer.user))

      if offered_shift.present?
        Shift.create(new_shift_attributes(offered_shift, trade.user))
      end
    end
    true
  rescue StandardError => error
    Bugsnag.notify(error)
    false
  end

  private

  attr_reader :offer, :trade

  def new_shift_attributes(shift, user)
    shift.
      attributes.
      slice("company_id", "minute_start", "minute_end", "date", "location_id").
      merge({ user_id: user.id })
  end

  def for_trade_shift
    trade.shift
  end

  def offered_shift
    offer.offered_shift
  end

  def with_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end
end
