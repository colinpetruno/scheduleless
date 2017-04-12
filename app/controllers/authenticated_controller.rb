class AuthenticatedController < ApplicationController
  layout "application"

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  before_action :authenticate_user!

  helper_method :current_company, :search_params

  def current_company
    current_user.company
  end

  def search_params
    params[:search] || {}
  end
end
