class ApiAuthenticatedController < ActionController::API
  include Pundit

  before_action :doorkeeper_authorize!

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def pundit_user
    UserContext.new(location: @location, user: current_user)
  end

  def current_company
    current_user.company
  end
end
