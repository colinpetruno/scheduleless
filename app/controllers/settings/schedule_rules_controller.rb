module Settings
  class ScheduleRulesController < AuthenticatedController
    def index
      authorize ScheduleRule

      @schedule_rules = current_company.schedule_rules
      @schedule_rule = ScheduleRule.new
    end

    def create
      authorize ScheduleRule

      @schedule_rule = current_company.
        schedule_rules.
        build(schedule_rule_params)

      if @schedule_rule.save
        redirect_to settings_schedule_rules_path
      else
        # TODO: Handle Error
      end
    end

    private

    def schedule_rule_params
      params.
        require(:schedule_rule).
        permit(:number_of_employees, :period, :position_id)
    end
  end
end
