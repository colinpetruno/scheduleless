class Onboarding::CompanyPreferencesController < AuthenticatedController
  layout "onboarding"

  def new
    @preferences = current_company.build_company_preferences
  end

  def create

  end
end
