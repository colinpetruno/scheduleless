class OfferAccept
  attr_reader :offer

  def self.for(offer)
    new(offer: offer)
  end

  def initialize(offer:)
    @offer = offer
  end

  def accept
    if can_accept_offer?
      ShiftTrader.new(offer: offer, trade: offer.trade).execute
    end
  end

  private

  def can_accept_offer?
    true
  end

  def tradee_can_accept?
    # TODO: if the dates are in the same week we need to account for only the difference in total minutes
    if shifts_in_same_period?

    else
    AvailabilityChecker.new(date: offered_shift.date, minutes_to_add: offered_shift)
    end
  end

  def offered_shift
    offer.offered_shift
  end

  def offered_shift_date
    Date.parse(offered_shift.date.to_s)
  end

  def offered_shift_week
    (offered_shift_date.beginning_of_week(:monday)..offered_shift_date.end_of_week(:monday))
  end

  def shifts_in_same_period?
    offered_shift_week.include?(traded_shift_date)
  end

  def traded_shift
    trade.shfit
  end

  def traded_shift_date
    Date.parse(traded_shift.date.to_s)
  end
end
