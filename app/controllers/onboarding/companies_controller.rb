module Onboarding
  class CompaniesController < AuthenticatedController
    layout "onboarding"

    def edit
      @company = current_company

      authorize @company
    end
  end
end
