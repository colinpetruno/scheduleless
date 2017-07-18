class SchedulingHourPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.locations.first.scheduling_hours
    end
  end

  def create?
    UserPermissions.for(user).company_admin?
  end

  def destroy?
    UserPermissions.for(user).company_admin?
  end

  def edit?
    UserPermissions.for(user).company_admin?
  end

  def index?
    UserPermissions.for(user).company_admin?
  end

  def update?
    UserPermissions.for(user).company_admin?
  end
end
