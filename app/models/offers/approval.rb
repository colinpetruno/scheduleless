module Offers
  class Approval
    def self.for(offer)
      new(offer: offer)
    end

    def initialize(offer:)
      @offer = offer
    end

    def location
      offer.trade.location
    end

    def perform
      # ActiveRecord::Base
      ActiveRecord::Base.transaction do
        offer.update(state: :completed)

        if offer.offered_shift_id.present?
          Shifts::Trader.new(offer: offer, trade: offer.trade).execute
        else
          Shifts::Taker.new(trade: offer.trade, user: offer.user).take
        end
      end

      # TODO: Send notifications
    end

    private

    attr_reader :offer
  end
end
