class HomesController < AuthenticatedController
  skip_after_action  :verify_authorized

  def show
    @hide_side_nav = true
  end
end
