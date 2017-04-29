class OfferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(company_id: user.company_id)
    end
  end
end
