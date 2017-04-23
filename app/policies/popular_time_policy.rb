class PopularTimePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.company_admin?
  end

  def new?
    user.company_admin?
  end
end
