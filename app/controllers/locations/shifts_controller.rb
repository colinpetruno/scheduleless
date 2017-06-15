module Locations
  class ShiftsController < AuthenticatedController

    def create
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.shifts.build(shift_params)
      authorize @shift

      model_params = params[:shift]
      shift_date = model_params[:year] + model_params[:month] + model_params[:date]

      @shift[:date] = shift_date.to_i

      if @shift.save
        redirect_to location_calendar_path, notice: t("shifts.create.notice")
      else
        redirect_to location_calendar_path, alert: t("shifts.create.alert")
      end

    end

    private

    def shift_params
      params.
        require(:shift).
        permit(:minute_start,
               :minute_end,
               :user_id).
        merge(location_id: @location.id,
              company_id: current_company.id)
    end
  end
end
