class ApiAuthenticatedController < ActionController::API
  before_action :doorkeeper_authorize!

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_company
    current_user.company
  end
end
