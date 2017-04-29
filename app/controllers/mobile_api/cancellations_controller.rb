module MobileApi
  class CancellationsController < ApiAuthenticatedController
    def create
      @cancellation = Cancellation.for(shift)

      authorize @cancellation

      if @cancellation.cancel
        render json: { cancellation: true }, status: :ok
      else
        render json: { cancellation: false }, status: :ok
      end
    end

    private

    def shift
      @_shift ||= Shift.find(params[:shift_id])
    end
  end
end
