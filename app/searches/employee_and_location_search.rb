class EmployeeAndLocationSearch
  include ActiveModel::Model

  attr_accessor :company_id, :query

  def results
    @_results ||= search.load
  end

  private

  def search
    [query_string, company_id_filter, score].compact.reduce(:merge)
  end

  def company_id_filter
    index.filter(term: { company_id: company_id })
  end

  def query_string
    index.
      query(query_string: {
              fields: fields,
              query: query,
              default_operator: 'and'
            })
  end

  def score
    index.min_score(0.9)
  end

  def index
    SiteSearchIndex
  end

  def fields
    [:email, :given_name, :family_name, :line_1, :line_2, :city]
  end
end
