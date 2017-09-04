class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :after_sign_in_path_for, :default_calendar_path_for, :reporting_path


  def default_calendar_path_for(user)
    location = Location.default_for(user)

    if location.present?
      location_new_calendar_path(location)
    else
      # TODO: this is going to need to get removed
      calendar_path
    end
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def pundit_user
    UserContext.new(location: @location, user: current_user)
  end
end
