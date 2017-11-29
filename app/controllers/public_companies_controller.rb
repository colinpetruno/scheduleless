class PublicCompaniesController < ApplicationController
  layout "blank"

  def show
    @company = PublicCompany.find_by!(uuid: params[:id])
  end
end
