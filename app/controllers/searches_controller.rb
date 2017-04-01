class SearchesController < AuthenticatedController
  def show
    @search_presenter = SearchPresenter.new(search)
  end

  private

  def search
    Search.new(search_params)
  end

  def search_params
    params.require(:search).permit(:query)
  end
end
