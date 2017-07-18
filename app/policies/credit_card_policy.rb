class CreditCardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.company.credit_cards.order(:created_at)
    end
  end

  def create?
    UserPermissions.for(user).company_admin?
  end

  def destroy?
    UserPermissions.for(user).company_admin?
  end

  def new?
    UserPermissions.for(user).company_admin?
  end

  def update?
    UserPermissions.for(user).company_admin?
  end
end
