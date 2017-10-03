module Dashboard
  class AvailableShiftsPresenter
    def initialize(user)
      @user = user
    end

    def trades?
      trades.present?
    end

    def trades
      @_trades ||= finder.first(5)
    end

    private

    attr_reader :user

    def finder
      @_finder ||= TradeFinder.for(user)
    end
  end
end
