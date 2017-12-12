class PublicReportsController < ApplicationController
  layout "marketing"

  def create
    @public_report = PublicReport.new(public_report_params)

    if @public_report.save
      redirect_to coworkability_share_path
    else
      render :new
    end
  end

  def new
    @company = find_public_company

    @public_report = PublicReport.new(public_company_id: @company.id)
  end

  private

  def find_public_company
    binding.pry
    if params[:public_company_id].present?
      PublicCompany.find_by!(uuid: params[:public_company_id])
    else
      PublicCompany.new(name: params[:company_name])
    end
  end

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
             :public_company_id,
             :name,
             :email,
             :gender,
             :race
            ).
    merge(ip_address: request.ip,
          remote_ip_address: request.remote_ip,
          user_agent: request.user_agent)
  end
end
