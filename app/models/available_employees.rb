class AvailableEmployees
  attr_reader :location, :query

  def initialize(location:, query:)
    @location = location
    @query = query
  end

  def retrieve
    location.
      company.
      users.
      where(id: matching_employees).
      where.not(id: existing_employees).
      order(:given_name, :family_name)
  end

  private

  def existing_employees
    location.users.pluck(:id)
  end

  def matching_employees
    UserSearch.
      new(query: query, company_id: location.company_id).
      search.
      map(&:id)
  end
end
