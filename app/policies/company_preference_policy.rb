class CompanyPreferencePolicy < ApplicationPolicy
  def edit?
    user.company_admin? && same_company?
  end

  def update?
    user.company_admin? && same_company?
  end
end
