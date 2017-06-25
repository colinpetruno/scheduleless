module Locations
  class InProgressShiftsController < AuthenticatedController

    def create
      @location = current_company.locations.find(params[:location_id])

      @in_progress_shift = InProgressShift.new(in_progress_shift_params)

      authorize :in_progress_shift, :create?

      if @in_progress_shift.save
        redirect_to(
          locations_location_scheduling_period_path(
            @location,
            @in_progress_shift.scheduling_period,
            date: @in_progress_shift.date
          )
        )
      else
        render :new
      end
    end


    def destroy
      @location = current_company.locations.find(params[:location_id])

      @in_progress_shift = InProgressShift.
        where(company_id: current_company.id).
        find(params[:id])

      authorize :in_progress_shift, :destroy?

      if @in_progress_shift.destroy
        redirect_to locations_location_scheduling_period_path(
          @location,
          @in_progress_shift.scheduling_period,
          date: @in_progress_shift.date)
      else
        redirect_to locations_location_scheduling_period_path(
            @location,
            @in_progress_shift.scheduling_period,
            date: @in_progress_shift.date),
          alert: "We had an error deleting your shift"
      end
    end

    def edit
      @location = current_company.locations.find(params[:location_id])
      @in_progress_shift = InProgressShift.
        where(company_id: current_company.id).
        find(params[:id])

      authorize :in_progress_shift, :edit?
    end

    def new
      @location = current_company.locations.find(params[:location_id])

      @in_progress_shift = InProgressShift.
        new(
          company_id: current_company.id,
          date: params[:date],
          scheduling_period_id: params[:scheduling_period_id]
        )

      authorize :in_progress_shift, :new?
    end

    def update
      @location = current_company.locations.find(params[:location_id])
      @in_progress_shift = InProgressShift.
        where(company_id: current_company.id).
        find(params[:id])

      authorize :in_progress_shift, :update?

      if @in_progress_shift.update(in_progress_shift_params)
        redirect_to locations_location_scheduling_period_path(
          @location,
          @in_progress_shift.scheduling_period,
          date: @in_progress_shift.date
        )
      else
        render :edit
      end
    end

    private

    def in_progress_shift_params
      params.
        require(:in_progress_shift).
        permit(
          :date,
          :minute_end,
          :minute_start,
          :scheduling_period_id,
          :user_id).
        merge(
          company_id: current_company.id,
          location_id: params[:location_id]
        )
    end
  end
end
