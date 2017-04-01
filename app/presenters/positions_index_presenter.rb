class PositionsIndexPresenter
  def initialize(company)
    @company = company
  end

  def partial_name
    if positions.present?
      "positions"
    else
      "no_positions"
    end
  end

  def positions
    company.positions.order(:name)
  end

  private

  attr_reader :company
end
