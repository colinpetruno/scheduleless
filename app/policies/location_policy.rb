class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.company_admin?
        user.company.locations
      else
        user.locations
      end
    end
  end

  def create?
    user.company_admin?
  end

  def edit?
    user.company_admin? && same_company?
  end

  def index?
    user.company_admin?
  end

  def new?
    user.company_admin?
  end

  def show?
    same_company?
  end

  def update?
    user.company_admin? && same_company?
  end
end
