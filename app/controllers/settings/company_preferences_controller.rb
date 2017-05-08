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
      current_company.preference
    end

    def company_preference_params
      params.
        require(:preference).
        permit(
          :break_length,
          :maximum_shift_length,
          :minimum_shift_length,
          :shift_overlap
        )
    end
  end
end
