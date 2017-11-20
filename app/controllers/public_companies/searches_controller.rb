module PublicCompanies
  class SearchesController < ApplicationController
    layout "blank"

    def index
      # binding.pry
      if search_params.present?
        @results = CompanySearch.
          new(query: search_params[:query]).
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
