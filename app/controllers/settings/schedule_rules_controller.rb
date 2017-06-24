module Settings
  class ScheduleRulesController < AuthenticatedController

    def create
      authorize ScheduleRule

      @schedule_rule = current_company.
        schedule_rules.
        build(schedule_rule_params)

      if @schedule_rule.save
        redirect_to settings_schedule_rules_path
      else
        @schedule_rules = policy_scope ScheduleRule
        render :index
      end
    end

    def destroy
      @schedule_rule = current_company.schedule_rules.find(params[:id])
      authorize @schedule_rule

      if @schedule_rule.destroy
        redirect_to settings_schedule_rules_path,
          notice: t("settings.schedule_rules.controller.notice")
      else
        redirect_to settings_schedule_rules_path,
          alert: t("settings.schedule_rules.controller.alert")
      end
    end

    def edit
      @schedule_rule = current_company.schedule_rules.find(params[:id])
      authorize @schedule_rule
    end

    def index
      @schedule_rules = policy_scope ScheduleRule
      @schedule_rule = ScheduleRule.new
    end

    def update
      @schedule_rule = current_company.schedule_rules.find(params[:id])
      authorize @schedule_rule

      if @schedule_rule.update(schedule_rule_params)
        redirect_to settings_schedule_rules_path
      else
        render :edit
      end
    end

    private

    def schedule_rule_params
      params.
        require(:schedule_rule).
        permit(:number_of_employees, :period, :position_id, :day)
    end
  end
end
