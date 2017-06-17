module Admin
  class CompaniesController < AdminController
    def destroy
      @company = Company.find(params[:id])

      if CompanyDestroyer.for(@company).destroy
        redirect_to admin_companies_path, notice: "Company Destroyed"
      else
        redirect_to admin_companies_path, alert: "Company Destroyed Failed"
      end
    end

    def edit
      @company = Company.find(params[:id])
    end

    def index
      @companies = Company.all
    end

    def update
      @company = Company.find(params[:id])

      if @company.update(company_params)
        redirect_to edit_admin_company_path(@company), notice: "Company Updated"
      else
        render :edit
      end
    end

    private

    def company_params
      params.require(:company).permit(:name, :demo)
    end
  end
end
