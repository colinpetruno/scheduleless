class AuthenticatedController < ApplicationController
  layout "application"

  before_action :authenticate_user!
  helper_method :current_company, :search_params

  def current_company
    current_user.company
  end

  def search_params
    params[:search] || {}
  end
end
