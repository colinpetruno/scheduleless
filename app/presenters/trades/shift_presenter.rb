module Trades
  class ShiftPresenter
    attr_reader :hide_actions, :trade, :user

    def initialize(trade:, user:, hide_actions: false)
      @hide_actions = hide_actions
      @trade = trade
      @user = user
    end

    def actions_partial
      if hide_actions
        "shared/blank"
      elsif trade.user_id == user.id
        "trades/owner_actions"
      else
        "trades/offer_actions"
      end
    end

    def day
      shift_date.day
    end

    def made_offer?
      trade.offers.any? { |offer| offer.user_id == user.id }
    end

    def month
      shift_date.month
    end

    def shift
      @_shift ||= trade.shift
    end

    def time
      "#{shift_start_time} - #{shift_end_time}"
    end

    def waiting_approval?
      # TODO: Could avoid a query here by iterating over the offers
      trade.offers.exists?(state: :waiting_approval)
    end

    private

    def shift_date
      @_shift_date ||= DateAndTime::Parser.new(date: shift.date)
    end

    def shift_end_time
      MinutesToTime.for(trade.shift.minute_end)
    end

    def shift_start_time
      @_shift_time ||= MinutesToTime.for(shift.minute_start)
    end
  end
end
