module Onboarding
  class ScheduleSettingsController < AuthenticatedController
    layout "onboarding"

    def edit
      authorize :schedule_setting, :edit?

      @schedule_setting = current_company.schedule_setting
    end

    def update
      authorize :schedule_setting, :update?
    end
  end
end
