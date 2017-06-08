class ApprovalsController < AuthenticatedController
  def index
    @scheduling_periods = policy_scope :schedule_approval
  end
end
