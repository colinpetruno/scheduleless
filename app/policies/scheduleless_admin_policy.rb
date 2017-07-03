class SchedulelessAdminPolicy < ApplicationPolicy
  def create?
    user.scheduleless_admin?
  end

  def destroy?
    user.scheduleless_admin?
  end

  def edit?
    user.scheduleless_admin?
  end

  def new?
    user.scheduleless_admin?
  end

  def show?
    user.scheduleless_admin?
  end
end
