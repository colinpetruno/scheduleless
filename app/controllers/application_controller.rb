class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :after_sign_in_path_for, :default_calendar_path_for


  def default_calendar_path_for(user)
    after_sign_in_path_for(user)
  end

  def after_sign_in_path_for(resource)
    location = Location.default_for(resource)

    if location.present?
      location_calendar_path(location)
    else
      calendar_path
    end
  end

  def pundit_user
    UserContext.new(location: @location, user: current_user)
  end
end
