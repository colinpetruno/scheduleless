class AuthenticatedController < ApplicationController
  layout "application"

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  before_action :authenticate_user!
  before_action :set_locale

  helper_method :current_company, :search_params, :reporting_path

  def current_company
    current_user.company
  end

  def search_params
    params[:search] || {}
  end

  def reporting_path
    location = Location.default_for(current_user)

    if params[:location_id]
      location = Location.find(params[:location_id])
    end

    location_statistics_path(location)
  end

  def set_locale
    I18n.locale = current_user.locale || I18n.default_locale
  end
end
