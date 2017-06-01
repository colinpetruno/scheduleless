class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.company_admin?
        UserFinder.new(user: user).by_company_without_current_user
      else
        UserFinder.new(user: user).by_associated_locations
      end
    end
  end

  def create?
    user.company_admin? || location_admin_for?(current_location)
  end

  def destroy?
    user.company_admin? || location_admin_for?(current_location)
  end

  def edit?
    user.company_admin? || own_profile? || location_admin_for?(current_location)
  end

  def show?
    user.company == record.company
  end

  def update?
    user.company_admin? || own_profile? || location_admin_for?(current_location)
  end

  private

  def own_profile?
    user.id == record.id
  end
end
