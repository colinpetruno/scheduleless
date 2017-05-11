class CreditCardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.company.credit_cards.order(:created_at)
    end
  end

  def create?
    user.company_admin?
  end

  def destroy?
    user.company_admin?
  end

  def new?
    user.company_admin?
  end

  def update?
    user.company_admin?
  end
end
