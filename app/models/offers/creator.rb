module Offers
  class Creator
    def initialize(company, trade, params={})
      @company = company
      @params = params
      @trade = trade
    end

    def offer
      @_offer ||= trade.offers.build(params)
    end

    def save
      if offer.save
        queue_notifications

        true
      else
        false
      end
    end

    private

    attr_reader :company, :params, :trade

    def queue_notifications
      # TODO: Notifications
    end
  end
end
