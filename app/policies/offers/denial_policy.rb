module Offers
  class DenialPolicy < ApplicationPolicy
    def create?
      UserPermissions.for(user).manage?(record.location)
    end
  end
end
