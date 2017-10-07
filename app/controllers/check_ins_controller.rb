class CheckInsController < AuthenticatedController
  def create
    check_in_creator = CheckInCreator.for(shift)

    authorize check_in_creator.check_in

    if check_in_creator.save
      # TODO: is this the right place to send someone?
      # TODO: Will need some sort of flash here temporaily
      redirect_to dashboard_path
     else
      # TODO: Error stuff
    end
  end

  private

  def shift
    @shift ||= Shifts::Finder.for(current_user).find_by(id: params[:shift_id])
  end
end
