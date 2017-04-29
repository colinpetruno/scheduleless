class CancellationsController < AuthenticatedController
  def create
    @cancellation = Cancellation.for(shift)

    authorize @cancellation

    if @cancellation.cancel
      redirect_to shifts_path
    else
      # TODO: oh what to do
    end
  end

  private

  def shift
    @_shift ||= Shift.find(params[:shift_id])
  end
end
