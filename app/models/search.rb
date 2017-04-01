class Search
  include ActiveModel::Model

  attr_accessor :query

  def results
    @_results ||= index.
      query(multi_match: {
        query: query,
        fields: fields
      }).
      load
  end

  private

  def index
    SiteSearchIndex
  end

  def fields
    ['email', 'given_name', 'line_1', 'line_2', 'city']
  end
end
