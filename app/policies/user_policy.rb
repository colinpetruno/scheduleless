class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.company_admin?
        user.company.users
      else
        User.
          joins(:user_locations).
          where(company: user.company).
          where(user_locations: { location_id: user.locations })
      end
    end
  end

  def create?
    user.company_admin?
  end

  def destroy?
    user.company_admin?
  end

  def edit?
    user.company_admin? || own_profile?
  end

  def show?
    user.company == record.company
  end

  def update?
    user.company_admin? || own_profile?
  end

  private

  def own_profile?
    user.id == record.id
  end
end
