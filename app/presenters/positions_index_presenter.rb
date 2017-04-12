class PositionsIndexPresenter
  attr_reader :positions

  def initialize(company, positions)
    @company = company
    @positions = positions
  end

  def partial_name
    if positions.present?
      "positions"
    else
      "no_positions"
    end
  end

  private

  attr_reader :company
end
