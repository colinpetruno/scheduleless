class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :after_sign_in_path_for

  def after_sign_in_path_for(resource)
    location = Location.default_for(resource)

    if location.present?
      location_calendar_path(location)
    else
      # TODO: HMMM where to go
    end
  end
end
