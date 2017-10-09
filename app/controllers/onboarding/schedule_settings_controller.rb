module Onboarding
  class ScheduleSettingsController < BaseController
    # TODO: this controller could be a bit weird because schedule setting
    # is really now a wrapper around company. However since company already
    # has an action it would be annoying to use the same controller but I feel
    # theres a better way
    layout "onboarding"

    def show
      # This route is to ensure if a user pushes back in the browser they don't
      # get a 404, instead just direct them back to edit so they can continue
      # going back
      skip_authorization
      redirect_to edit_onboarding_schedule_settings_path and return
    end

    def edit
      authorize :schedule_setting, :edit?

      @schedule_setting = ScheduleSetting.
        new(company: current_company,
            start_day: current_company.schedule_start_day,
            payment_method: current_company.pay_by_type)
    end

    def update
      authorize :schedule_setting, :update?

      schedule_setting = ScheduleSetting.new(schedule_setting_params)

      if schedule_setting.update
        Onboarding::Status.for(current_company).move_to_next_step!(7)
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
          :start_day,
          :payment_method
        ).merge(company: current_company)
    end
  end
end
