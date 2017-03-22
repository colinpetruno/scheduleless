module Settings
  class PositionsController < AuthenticatedController
    def index
      @positions = current_company.positions
    end

    def new
      @position = current_company.positions.build
    end

    def create
      @position = current_company.positions.build(position_params)

      if @position.save
        redirect_to settings_positions_path
      else
        # TODO: HANDLE ERRROR
      end
    end

    private

    def position_params
      params.
        require(:position).
        permit(:name)
    end
  end
end
