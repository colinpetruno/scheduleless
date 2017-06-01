class EmployeePositionPolicy < ApplicationPolicy
  def destroy?
    user.company_admin? || location_admin_for?(current_location)
  end
end
