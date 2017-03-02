class AuthenticatedController < ApplicationController
  layout "application"

  helper_method :current_company

  def current_company
    current_user.company
  end

end
