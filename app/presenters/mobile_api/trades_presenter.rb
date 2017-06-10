module MobileApi
  class TradesPresenter
    def self.for(trades)
      new(trades: trades)
    end

    def initialize(trades:)
      @trades = trades
    end

    def as_json(_options={})
      trades.map do |trade|
        TradePresenter.for(trade).as_json
      end
    end

    private

    attr_reader :trades
  end
end
