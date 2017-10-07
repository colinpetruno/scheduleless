module Offers
  class AcceptPolicy < ApplicationPolicy
    def create?
      user.locations.include?(record.offer.trade.location)
    end
  end
end
