class CreditCardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.company.credit_cards
    end
  end

  def new?
    user.company_admin?
  end
end
