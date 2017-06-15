class ShiftsController < AuthenticatedController
  def index
    @shifts = policy_scope(Shift)
  end

  def edit
    @location = current_company.locations.find(params[:location_id])
    @shift = @location.shifts.find(params[:id])
    @users = @location.users

    date_parse = DateParser.new(date: @shift[:date])

    @shift.year = (@shift[:date]*0.0001).round(0)
    @shift.month =  date_parse.month_number
    @shift.date =  date_parse.day.to_i

    authorize @shift
  end

  def update
    @location = current_company.locations.find(params[:location_id])
    @shift = @location.shifts.find(params[:id])
    authorize @shift

    @shift.update(shift_params)

    model_params = params[:shift]
    shift_date = model_params[:year] + model_params[:month] + model_params[:date]

    @shift[:date] = shift_date.to_i

    if @shift.update
      redirect_to location_calendar_path(@location), notice: t("shifts.edit.notice")
    else
      redirect_to location_calendar_path(@location), alert: t("shifts.edit.notice")
    end

  end

  def new
    @location = current_company.locations.find(params[:location_id])
    @shift = @location.shifts.build
    @users = @location.users

    @shift.year = TimeRange.year_options[0]
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
