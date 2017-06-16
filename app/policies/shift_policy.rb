class ShiftPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      ShiftFinder.for(user).future.find
    end
  end

  def edit?
    user.company_admin? || location_admin_for?(shift_location)
  end

  def new?
    user.company_admin? || location_admin_for?(shift_location)
  end

  def create?
    user.company_admin? || location_admin_for?(shift_location)
  end

  def destroy?
    user.company_admin? || location_admin_for?(shift_location)
  end

  def update?
    user.company_admin? || location_admin_for?(shift_location)
  end

  private

  def shift_location
    record.location
  end
end
