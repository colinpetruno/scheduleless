module Settings
  class PositionsController < AuthenticatedController
    def index
      authorize Position
      positions = policy_scope(Position).order(:name)

      @positions_presenter = PositionsIndexPresenter.
        new(current_company, positions)
    end

    def new
      authorize Position

      @position = current_company.positions.build
    end

    def create
      authorize Position

      @position = current_company.
        positions.
        build(permitted_attributes(Position))

      if @position.save
        redirect_to settings_positions_path
      else
        # TODO: HANDLE ERRROR
      end
    end
  end
end
