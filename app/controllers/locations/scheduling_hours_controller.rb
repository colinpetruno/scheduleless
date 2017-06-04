module Locations
  class SchedulingHoursController < AuthenticatedController
    def index
      @location = current_company.locations.find(params[:location_id])
      @scheduling_hours = policy_scope(SchedulingHour)
    end

    def new
      @location = current_company.locations.find(params[:location_id])
      @scheduling_hour = @location.scheduling_hours.build
      authorize @scheduling_hour
    end

    def edit
      @location = current_company.locations.find(params[:location_id])
      @scheduling_hour = @location.scheduling_hours.find(params[:id])
      authorize @scheduling_hour
    end

    def destroy
      @location = current_company.locations.find(params[:location_id])
      @scheduling_hour = @location.scheduling_hours.find(params[:id])
      authorize @scheduling_hour

      if @scheduling_hour.destroy
        redirect_to locations_location_scheduling_hours_path(@location), notice: t("locations.scheduling_hours.controller.notice")
      else
        redirect_to locations_location_scheduling_hours_path(@location), alert: t("locations.scheduling_hours.controller.alert")
      end
    end

    def create
      @location = current_company.locations.find(params[:location_id])
      @scheduling_hour = @location.scheduling_hours.build(scheduling_hour_params)
      authorize @scheduling_hour

      if @scheduling_hour.save
        redirect_to locations_location_scheduling_hours_path(@location)
      else
        render :new
      end
    end

    def update
      @location = current_company.locations.find(params[:location_id])
      @scheduling_hour = @location.scheduling_hours.find(params[:id])
      @scheduling_hour.update(scheduling_hour_params)
      authorize @scheduling_hour

      redirect_to locations_location_scheduling_hours_path
    end

    private

    def scheduling_hour_params
      params.
        require(:scheduling_hour).
        permit(:day,
               :minute_open_start,
               :minute_open_end,
               :minute_schedulable_start,
               :minute_schedulable_end).
        merge(location_id: @location.id)
    end

  end
end
