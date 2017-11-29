module Remote
  module Companies
    class SearchesController < ApplicationController
      def index
        @results = CompanySearch.
          new(query: SanitizedElasticsearchString.for(params[:query])).
          search.
          load


        render json: @results
      end
    end
  end
end
