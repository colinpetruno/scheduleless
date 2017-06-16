module Onboarding
  class ScheduleSettingsController < AuthenticatedController
    layout "onboarding"

    def edit
      authorize :schedule_setting, :edit?

      @schedule_setting = current_company.schedule_setting
    end

    def update
      authorize :schedule_setting, :update?

      updater = ScheduleSettingUpdater.for(schedule_setting_params)

      if updater.update
        render :update
      else
        render :edit
      end
    end

    private

    def schedule_setting_params
      params.
        require(:schedule_setting).
        permit(
          :lead_time,
          :note,
          :schedule_duration,
          :start_date
        ).
        merge(company: current_company)
    end
  end
end
