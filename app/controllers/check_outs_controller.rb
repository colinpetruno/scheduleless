class CheckOutsController < AuthenticatedController
  def create
    check_out = CheckOut.for(shift)

    authorize check_out

    if check_out.check_out
      # TODO: this is prob not the final place for this
      redirect_to dashboard_path
    else
      # TODO: figure out error
    end
  end

  private

  def shift
    @shift ||= Shifts::Finder.for(current_user).find_by(id: params[:shift_id])
  end
end
