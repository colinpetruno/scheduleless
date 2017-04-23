class UserLocationPolicy < ApplicationPolicy
  def create?
    user.company_admin?
  end
end
