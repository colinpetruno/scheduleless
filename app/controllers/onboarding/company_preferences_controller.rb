module  Onboarding
  class CompanyPreferencesController < BaseController
    layout "onboarding"

    def new
      @preferences = current_company.build_company_preferences
    end

    def create

    end
  end
end
