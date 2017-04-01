class SearchPresenter
  def initialize(search)
    @search = search
  end

  def partial_name
    if results.present?
      "results"
    else
      "no_results"
    end
  end

  def results
    search.results.to_a
  end

  private

  attr_reader :search
end
