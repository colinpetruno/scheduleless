class UserSearch
  attr_reader :company_id, :query

  def initialize(company_id:, query:)
    @company_id = company_id
    @query = query
  end

  def index
    SiteSearchIndex
  end

  def search
    [query_string, company_id_filter, score].compact.reduce(:merge)
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

  def company_id_filter
    index.filter(term: { company_id: company_id })
  end

  private

  def filter_fields
    [:email, :given_name, :family_name, :preferred_name]
  end
end

# UserSearch.new(query: "demo@example.com", company_id: 1).search
# UserSearch.new(query: "dem", company_id: 1).search.load.first
