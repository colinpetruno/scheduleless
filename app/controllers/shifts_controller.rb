class ShiftsController < AuthenticatedController
  def index
    @shifts = policy_scope(Shift)
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
