module Admin
  class ScheduleRulesController < AdminController
    def create
      @company = Company.find(params[:company_id])
      @schedule_rule = @company.schedule_rules.build(schedule_rule_params)

      if @schedule_rule.save
        redirect_to admin_company_schedule_rules_path(@company)
      else
        render :new
      end
    end

    def destroy
      @company = Company.find(params[:company_id])
      @schedule_rule = current_company.schedule_rules.find(params[:id])

      if @schedule_rule.destroy
        redirect_to admin_company_schedule_rules_path(@company),
          notice: "Schedule Rule Was Deleted"
      else
        redirect_to settings_schedule_rules_path,
          alert: "Something went wrong"
      end
    end

    def edit
      @company = Company.find(params[:company_id])
      @schedule_rule = @company.schedule_rules.find(params[:id])
    end

    def index
      @company = Company.find(params[:company_id])
      @schedule_rules = @company.schedule_rules
    end

    def new
      @company = Company.find(params[:company_id])
      @schedule_rule = @company.schedule_rules.build
    end

    def update
      @company = Company.find(params[:company_id])
      @schedule_rule = @company.schedule_rules.find(params[:id])

      if @schedule_rule.update(schedule_rule_params)
        redirect_to admin_company_schedule_rules_path(@company)
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
