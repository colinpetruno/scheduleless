class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :after_sign_in_path_for, :coworkability?, :current_domain,
    :current_user, :default_calendar_path_for, :default_reporting_path_for

  def current_user
    @current_user ||= current_login_user.user
  rescue
    nil
  end

  def default_calendar_path_for(user)
    location = Location.default_for(user)

    if location.present?
      location_calendar_path(location)
    else
      dashboard_path
    end
  end

  def default_reporting_path_for(user)
    location = Location.default_for(user)

    if location.present?
      reporting_location_time_sheet_path(location)
    else
      reporting_locations_path
    end
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def pundit_user
    if params[:location_id].present? && @location.blank?
      @location = current_company.locations.find(params[:location_id])
    end

    UserContext.new(location: @location, user: current_user)
  end

  def current_domain
    if request.host.include?("coworkability")
      "coworkability"
    else
      "scheduleless"
    end
  end

  def coworkability?
    if request.host.include?("coworkability")
      true
    else
      false
    end
  end
end
