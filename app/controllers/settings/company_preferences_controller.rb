module Settings
  class CompanyPreferencesController < AuthenticatedController
    def edit
      @company_preference = company_preference

      authorize @company_preference
    end

    def update
      @company_preference = company_preference

      authorize @company_preference

      if @company_preference.update(company_preference_params)
        redirect_to edit_settings_company_preference_path,
          notice: I18n.t("settings.preferences.company.success")
      else
        render :edit
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
          :minimum_hours_for_break,
          :preferred_shift_length,
          :minimum_shift_length,
          :paid_break,
          :shift_overlap
        )
    end
  end
end
