module Shifts
  class Taker
    def initialize(trade:, user:)
      @trade = trade
      @user = user
    end

    def take
      ActiveRecord::Base.transaction do
        Shifts::Transferer.new(new_user: user, shift: traded_shift).transfer

        trade.update(status: :completed)
      end
    end

    private

    attr_reader :new_shift, :trade, :user

    def traded_shift
      trade.shift
    end
  end
end
