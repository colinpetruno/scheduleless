module MobileApi
  class FutureShiftsController < ApiAuthenticatedController
    def show
      future_shifts = Shifts::Finder.
        for(current_user).
        future.
        includes(:location).
        find

      render json: {
        future_shifts: ShiftsPresenter.for(future_shifts)
      }, status: :ok
    end
  end
end
