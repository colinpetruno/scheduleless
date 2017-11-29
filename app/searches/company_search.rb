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
      default_operator: "and"
    })
  end

  def score
    # seems like 5 is about right... why 5 (¯\_(ツ)_/¯)
    # need to figure out how to take the most relevant items based on scores here
    index.min_score(5)
  end

  private

  def filter_fields
    [:name]
  end
end
