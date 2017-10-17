module Offers
  class Accept
    attr_reader :offer

    def self.for(offer)
      new(offer: offer)
    end

    def initialize(offer:)
      @offer = offer
      @trade = offer.trade
    end

    def accept
      if trade_needs_approval?
        # if it needs approval it needs kicked to the manager
        offer.update(state: :waiting_approval)
      elsif offer_is_a_trade?
        ShiftTrader.new(offer: offer, trade: offer.trade).execute
      else
        # if it does not need approval and the shift is a take use shift taker
        ShiftTaker.new(trade: trade, user: offer.user).take
      end

      Notifications::Offers::AcceptedJob.perform_later(offer.id)
    end

    private

    attr_reader :trade

    def preferences
      @_preferences ||= PreferenceFinder.for(trade.location)
    end

    def offer_is_a_trade?
      offer.shift_id.present?
    end

    def offered_shift
      offer.offered_shift
    end

    def trade_needs_approval?
      preferences.approve_trades?
    end

    def traded_shift
      trade.shift
    end
  end
end
