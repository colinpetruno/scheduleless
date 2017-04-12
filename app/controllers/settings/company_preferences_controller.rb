module Settings
  class CompanyPreferencesController < AuthenticatedController
    def edit
      @company_preference = company_preference

      authorize @company_preference
    end

    def update
      authorize company_preference

      if company_preference.update(company_preference_params)
        redirect_to settings_path
      else
        # TODO: handle error
      end
    end

    private

    def company_preference
      current_company.company_preference
    end

    def company_preference_params
      params.
        require(:company_preference).
        permit(:shift_overlap)
    end
  end
end
