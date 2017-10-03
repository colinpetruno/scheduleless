module Offers
  class Creator
    def initialize(company, trade, params={})
      @company = company
      @params = params
      @trade = trade
    end

    def offer
      @_offer ||= trade.offers.build(offer_params)
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

    def default_params
      if offer_state == :accepted
        { state: :accepted, accepted_or_declined_at: DateTime.now }
      elsif offer_state != :offered
        { state: offer_state }
      else
        {}
      end
    end

    def preferences
      @_preferences ||= PreferenceFinder.for(trade.location)
    end

    def offer_params
      params.merge(default_params)
    end

    def offer_state
      if params[:offered_shift_id].blank?
        if preferences.approve_trades?
          :waiting_approval
        else
          :accepted
        end
      else
        :offered
      end
    end

    def queue_notifications
      # TODO: Notifications
    end
  end
end
