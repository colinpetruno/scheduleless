module Remote
  class InProgressShiftsController < AuthenticatedController
    def create
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.build(in_progress_shift_params)

      authorize @shift

      @shift.save
    end

    def edit
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.find(params[:id])

      authorize @shift
    end

    def new
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.build(shift_get_params)

      authorize @shift
    end

    def update
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.find(params[:id])

      authorize @shift

      @shift.update(in_progress_shift_params.merge(edited: true))
    end

    private

    def in_progress_shift_params
      params.
        require(:in_progress_shift).
        permit(:date,
               :minute_end,
               :minute_start,
               :user_id).
        merge(company_id: current_company.id,
              location_id: params[:location_id])
    end

    def shift_get_params
      shift_param_hash = { date: params[:date] }
      shift_param_hash.merge!(user_id: user.id) if user.present?
      shift_param_hash
    end

    def user
      current_company.users.find(params[:user_id])
    rescue
      nil
    end
  end
end
