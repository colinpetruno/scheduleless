class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if UserPermissions.for(user).company_admin?
        UserFinder.new(user: user).by_company_without_current_user
      else
        UserFinder.new(user: user).by_associated_locations
      end
    end
  end

  def create?
    # might not be a location for a user
    permission = UserPermissions.for(user)

    record.locations.map do |location|
      permission.manage?(location)
    end.exclude?(false)
  end

  def destroy?
    UserPermissions.for(user).manage?(record)
  end

  def edit?
    UserPermissions.for(user).manage?(record) || own_profile?
  end

  def new?
    UserPermissions.for(user).manager?
  end

  def show?
    user.company == record.company
  end

  def update?
    UserPermissions.for(user).manage?(record) || own_profile?
  end

  private

  def own_profile?
    user.id == record.id
  end
end
