module Locations
  class ScheduleRulesController < AuthenticatedController

    def create
      @location = location
      authorize ScheduleRule

      @schedule_rule = @location.
        schedule_rules.
        build(schedule_rule_params)

      if @schedule_rule.save
        redirect_to locations_location_schedule_rules_path(@location)
      else
        @schedule_rules = policy_scope ScheduleRule
        render :index
      end
    end

    def destroy
      @location = location
      @schedule_rule = @location.schedule_rules.find(params[:id])
      authorize @schedule_rule

      if @schedule_rule.destroy
        # TODO UPDATE ME
        redirect_to locations_location_schedule_rules_path(@location),
          notice: t("locations.schedule_rules.controller.notice")
      else
        redirect_to locations_location_schedule_rules_path(@location),
          alert: t("locations.schedule_rules.controller.alert")
      end
    end

    def edit
      @location = location
      @schedule_rule = @location.schedule_rules.find(params[:id])
      authorize @schedule_rule
    end

    def index
      @location = location
      @schedule_rules = policy_scope(ScheduleRule)

      @schedule_rule = @location.schedule_rules.build
    end

    def update
      @location = location
      @schedule_rule = @location.schedule_rules.find(params[:id])
      authorize @schedule_rule

      if @schedule_rule.update(schedule_rule_params)
        redirect_to locations_location_schedule_rules_path
      else
        render :edit
      end
    end

    private

    def location
      current_company.locations.find(params[:location_id])
    end

    def schedule_rule_params
      params.
        require(:schedule_rule).
        permit(:number_of_employees, :period, :position_id, :day)
    end
  end
end
