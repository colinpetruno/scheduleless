module MobileApi
  class CancellationsController < ApiAuthenticatedController
    def create
      @cancellation = Cancellation.
        new(note: cancellation_params[:note], shift: shift)

      authorize @cancellation

      if @cancellation.cancel
        render json: {
          cancellation: MobileApi::ShiftPresenter.for(shift)
        }, status: :ok
      else
        render json: { cancellation: false }, status: :ok
      end
    end

    private

    def cancellation_params
      params.require(:cancellation).permit(:note)
    end

    def shift
      @_shift ||= Shift.find(params[:shift_id])
    end
  end
end
