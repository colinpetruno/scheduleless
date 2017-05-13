class OfferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.offered.where(company_id: user.company_id)
    end
  end

  def create?
    #TODO fill this out
    true
  end

  def new?
    # TODO: Check location for trade is available for the user
    true
  end
end
