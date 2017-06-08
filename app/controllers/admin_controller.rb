class AdminController < AuthenticatedController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  before_action :authorize_admin!

  private

  def authorize_admin!
    unless current_user.scheduleless_admin?
      raise ActionController::RoutingError, "Not Found"
    end
  end
end
