class LeadPolicy < ApplicationPolicy
  def create?
    true
  end

  def new?
    true
  end
end
