module PublicCompanies
  class PublicReportsController < ApplicationController
    layout "blank"

    def create
      @company = PublicCompany.find(params[:public_company_id])

      @public_report = PublicReport.new(public_report_params)

      if @public_report.save
        redirect_to coworkability_share_path
      else
        render :new
      end
    end

    def new
      @company = PublicCompany.find(params[:public_company_id])

      @public_report = PublicReport.new
    end

    private

    def public_report_params
      params.
        require(:public_report).
        permit(:role,
               :incident_date,
               :still_happening,
               :comitted_by,
               :what_happened,
               :category,
               :notified_others,
               :reported_to,
               :experienced_retaliation,
               :job_affected,
               :job_affected_description,
               :others_present,
               :others_affected,
               :sought_treatment,
               :handled_description,
               :handled_satisfied,
               :preferred_handling,
               :name,
               :email
              )
    end
  end
end
