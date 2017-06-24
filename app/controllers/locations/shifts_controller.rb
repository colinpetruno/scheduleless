module Locations
  class ShiftsController < AuthenticatedController
    def create
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.shifts.build(shift_params)
      authorize @shift

      # TODO: Remove controller logic
      model_params = params[:shift]
      shift_date = model_params[:year] + model_params[:month] + model_params[:day]

      @shift[:date] = shift_date.to_i

      if @shift.save
        redirect_to(
          location_calendar_path(date: @shift.date),
          notice: t("shifts.create.notice")
        )
      else
        redirect_to(
          location_calendar_path(date: @shift.date),
          alert: t("shifts.create.alert")
        )
      end
    end

    def destroy
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.shifts.find(params[:id])
      authorize @shift

      if @shift.destroy
        redirect_to(
          location_calendar_path(@location, date: @shift.date),
          notice: t("shifts.destroy.notice")
        )
      else
        redirect_to(
          location_calendar_path(@location, date: @shift.date),
          alert: t("shifts.destroy.alert")
        )
      end
    end

    def edit
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.shifts.find(params[:id])
      @users = @location.users

      authorize @shift
    end

    def new
      date = Date.parse(params[:date]).strftime('%Y%m%d').to_i
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.shifts.build(date: date)
      @users = @location.users

      authorize @shift
    end

    def update
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.shifts.find(params[:id])

      authorize @shift

      if @shift.update(shift_params)
        redirect_to(
         location_calendar_path(@location, date: @shift.date),
          notice: t("shifts.edit.notice")
        )
      else
        redirect_to(
          location_calendar_path(@location, date: @shift.date),
          alert: t("shifts.edit.notice")
        )
      end
    end

    private

    def shift_params
      params.
        require(:shift).
        permit(
          :day,
          :minute_start,
          :minute_end,
          :month,
          :user_id,
          :year
        ).
        merge(location_id: @location.id,
              company_id: current_company.id)
    end
  end
end
