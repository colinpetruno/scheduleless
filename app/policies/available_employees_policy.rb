class AvailableEmployeesPolicy < ApplicationPolicy
  def index?
    user.company_admin?
  end
end
