class PublicCompaniesController < ApplicationController
  layout "marketing"

  def show
    @company = PublicCompany.find_by!(uuid: params[:id])
  end
end
