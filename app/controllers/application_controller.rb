class ApplicationController < ActionController::Base
  include Pundit

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || calendar_path
  end

  protect_from_forgery with: :exception
end
