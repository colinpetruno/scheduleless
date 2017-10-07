module Shifts
  class Trader
    def initialize(offer:, trade:)
      @offer = offer
      @trade = trade
    end

    def execute
      ActiveRecord::Base.transaction do
        Shifts::Transferer.new(new_user: offer_user, shift: traded_shift).transfer
        Shifts::Transferer.new(new_user: trade_user, shift: offered_shift).transfer
      end

      # TODO send notifications
      true
    end

    private

    attr_reader :offer, :trade

    def offered_shift
      offer.offered_shift
    end

    def offer_user
      offer.user
    end

    def traded_shift
      trade.shift
    end

    def trade_user
      trade.user
    end
  end
end
