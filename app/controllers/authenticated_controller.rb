class AuthenticatedController < ApplicationController
  layout "application"

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  before_action :authenticate_user!
  before_action :set_locale

  helper_method :current_company, :search_params

  def current_company
    current_user.company
  end

  def search_params
    params[:search] || {}
  end

  def set_locale
    I18n.locale = current_user.locale || I18n.default_locale
  end
end
