class PublicCompaniesController < ApplicationController
  layout "blank"

  def show
    @company = PublicCompany.find(params[:id])
  end
end
