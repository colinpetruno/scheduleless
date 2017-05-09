class SubscriptionPolicy < ApplicationPolicy
  def edit?
    user.company_admin?
  end

  def update?
    user.company_admin?
  end
end
