module Shifts
  class Taker
    def initialize(trade:, user:)
      @trade = trade
      @user = user
    end

    def take
      ShiftsTransferer.new(new_user: user, shift: traded_shift).transfer

      # TODO: send notificaitons
    end

    private

    attr_reader :new_shift, :trade, :user

    def traded_shift
      trade.shift
    end
  end
end
