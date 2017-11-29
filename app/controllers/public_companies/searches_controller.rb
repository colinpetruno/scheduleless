module PublicCompanies
  class SearchesController < ApplicationController
    layout "blank"

    def index
      # binding.pry
      if search_params.present?
        @company = PublicCompany.find_by(name: search_params[:query])

        if @company.present?
          redirect_to public_company_path(@company) and return
        end

        @results = CompanySearch.
          new(query: SanitizedElasticsearchString.for(search_params[:query])).
          search.
          page(params[:page]).
          load
      end
    end

    private

    def search_params
      if params[:search].present?
        params[:search].permit(:query)
      else
        nil
      end
    end
  end
end
