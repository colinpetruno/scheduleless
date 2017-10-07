module Offers
  class ApprovalPolicy < ApplicationPolicy
    def create?
      UserPermissions.for(user).manage?(record.location)
    end
  end
end
