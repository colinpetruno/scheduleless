class SearchesController < AuthenticatedController
  def show
    authorize :search, :show?

    @search_presenter = SearchPresenter.new(search)
  end

  private

  def search
    EmployeeAndLocationSearch.new(search_params)
  end

  def search_params
    params.
      require(:employee_and_location_search).
      permit(:query).
      merge({ company_id: current_company.id })
  end
end
