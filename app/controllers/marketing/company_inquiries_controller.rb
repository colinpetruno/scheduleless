module Marketing
  class CompanyInquiriesController < BaseController
    def create
      @inquiry = CompanyInquiry.new(company_inquiry_params)

      if @inquiry.save
        redirect_to thanks_company_inquiries_path
      else
        render :new
      end
    end

    def new
      @inquiry = CompanyInquiry.new(new_company_inquiry_params)
    end

    def thanks
    end

    private

    def new_company_inquiry_params
      if params[:company].present?
        company = PublicCompany.find_by(uuid: params[:company])
        { company_name: company.name }
      else
        {}
      end
    rescue
      {}
    end

    def company_inquiry_params
      params.
        require(:company_inquiry).
        permit(:first_name, :last_name, :job_title, :company_name)
    end
  end
end
