class OfferAcceptPolicy < ApplicationPolicy
  def create?
    # TODO auth this
    true
  end
end
