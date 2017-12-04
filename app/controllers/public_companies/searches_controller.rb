module PublicCompanies
  class SearchesController < ApplicationController
    layout "marketing"

    def index
      # binding.pry
      if search_params.present?
        @company = PublicCompany.find_by(name: search_params[:query])

        if @company.present?
          redirect_to public_company_path(@company) and return
        end

        @company_search = PublicCompanySearch.new(search_params)

        @results = CompanySearch.
          new(query: SanitizedElasticsearchString.for(search_params[:query])).
          search.
          page(params[:page]).
          load
      end
    end

    private

    def search_params
      if params[:public_company_search].present?
        params[:public_company_search].permit(:query)
      else
        nil
      end
    end
  end
end
