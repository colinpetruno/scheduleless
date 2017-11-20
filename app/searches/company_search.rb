class CompanySearch
  attr_reader :query

  def initialize(query:)
    @query = query
  end

  def index
    CompanySearchIndex
  end

  def search
    [query_string, score].compact.reduce(:merge)
  end

  # Using query_string advanced query for the main query input
  def query_string
    index.query(query_string: {
      fields: filter_fields,
      query: query,
      default_operator: 'and'
    })
  end

  def score
    index.min_score(0.9)
  end

  private

  def filter_fields
    [:name]
  end
end
