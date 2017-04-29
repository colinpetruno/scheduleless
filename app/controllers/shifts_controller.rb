class ShiftsController < AuthenticatedController
  def index
    @shifts = policy_scope(Shift)
  end
end
