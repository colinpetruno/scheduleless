module Onboarding
  class CompaniesController < AuthenticatedController
    layout "onboarding"

    def edit
      @company = current_company
      authorize @company
    end

    def update
      @company = current_company

      authorize @company

      if @company.update(company_params)
        redirect_to new_onboarding_lead_path
      else
        render :edit
      end
    end

    private

    def company_params
      params.require(:company).permit(:name, :size)
    end
  end
end
