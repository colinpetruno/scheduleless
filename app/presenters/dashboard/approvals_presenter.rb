module Dashboard
  class ApprovalsPresenter
    def initialize(user)
      @user = user
    end

    def trade_approvals?
      offers.present?
    end

    def time_off_approvals
      @_time_off_requests = PendingTimeOffRequests.
        new(user: user).
        waiting_approval
    end

    def trade_approvals
      trade_map
    end

    def trade_for(id)
      trades.to_a.select { |t| t.id == id }.first
    end

    private

    attr_reader :user

    def build_trade_map
      map = {}

      offers.map do |offer|
        if map[offer.trade_id].present?
          map[offer.trade_id].push(offer)
        else
          map[offer.trade_id] = [offer]
        end
      end

      map
    end

    def location_ids
      locations.pluck(:id)
    end

    def locations
      if user_permissions.company_admin?
        @_locations ||= user.company.locations
      else
        @_locations ||= user.locations
      end
    end

    def offers
      @_offers ||= Offer.
        joins(:trade).
        where(trades: { location_id: location_ids }, state: :waiting_approval)
    end

    def trades
      @_trades ||= Trade.where(id: offers.map(&:trade_id)).includes(:shift)
    end

    def trade_map
      @_trade_map ||= build_trade_map
    end

    def user_permissions
      @_permissions = UserPermissions.for(user)
    end
  end
end
