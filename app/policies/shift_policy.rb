class ShiftPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      ShiftFinder.for(user).future.find
    end
  end

  def edit?
    UserPermissions.for(user).manage?(shift_location)
  end

  def new?
    UserPermissions.for(user).manage?(shift_location)
  end

  def create?
    UserPermissions.for(user).manage?(shift_location)
  end

  def destroy?
    UserPermissions.for(user).manage?(shift_location)
  end

  def update?
    UserPermissions.for(user).manage?(shift_location)
  end

  private

  def shift_location
    record.location
  end
end
