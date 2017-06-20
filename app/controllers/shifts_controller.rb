class ShiftsController < AuthenticatedController
  def index
    @shifts = policy_scope(Shift)
  end

  def edit
    @location = current_company.locations.find(params[:location_id])
    @shift = @location.shifts.find(params[:id])
    @users = @location.users

    authorize @shift
  end

  def update
    @location = current_company.locations.find(params[:location_id])
    @shift = @location.shifts.find(params[:id])

    authorize @shift

    if @shift.update(shift_params)
      redirect_to location_calendar_path(@location), notice: t("shifts.edit.notice")
    else
      redirect_to location_calendar_path(@location), alert: t("shifts.edit.notice")
    end

  end

  def new
    date = Date.parse(params[:date]).strftime('%Y%m%d').to_i
    @location = current_company.locations.find(params[:location_id])
    @shift = @location.shifts.build(date: date)
    @users = @location.users

    authorize @shift
  end

  def destroy
    @location = current_company.locations.find(params[:location_id])
    @shift = @location.shifts.find(params[:id])
    authorize @shift

    if @shift.destroy
      redirect_to location_calendar_path(@location), notice: t("shifts.destroy.notice")
    else
      redirect_to location_calendar_path(@location), alert: t("shifts.destroy.alert")
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
