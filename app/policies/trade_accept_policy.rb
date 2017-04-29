class TradeAcceptPolicy < ApplicationPolicy
  def create?
    # TODO: Auth this
    true
  end
end
