module PublicCompanies
  class PublicReportsController < ApplicationController
    layout "blank"

    def new
      @company = PublicCompany.find(params[:public_company_id])

      @public_report = PublicReport.new
    end
  end
end
