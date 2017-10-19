module Dashboard
  class AvailableShiftsPresenter
    def initialize(user)
      @user = user
    end

    def trades?
      trades.present?
    end

    def trades
      @_trades ||= finder.available_with_limit(5)
    end

    private

    attr_reader :user

    def finder
      @_finder ||= Trades::Finder.new(user: user)
    end
  end
end
