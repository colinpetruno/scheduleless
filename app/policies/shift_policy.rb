class ShiftPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      Shifts::Finder.for(user).future.find
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

  def show?
    # TODO: is this needed? placing it temporarily here to make the remote
    # action work in #shift_details_controller
    true
  end

  def update?
    UserPermissions.for(user).manage?(shift_location)
  end

  private

  def shift_location
    record.location
  end
end
