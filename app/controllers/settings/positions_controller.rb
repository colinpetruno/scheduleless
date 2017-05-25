module Settings
  class PositionsController < AuthenticatedController
    def create
      authorize Position

      @position = current_company.
        positions.
        build(permitted_attributes(Position))

      if @position.save
        redirect_to settings_positions_path
      else
        render :new
      end
    end

    def edit
      @position = current_company.positions.find(params[:id])

      authorize @position
    end

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

    def update
      @position = current_company.positions.find(params[:id])

      authorize @position

      if @position.update(permitted_attributes(Position))
        redirect_to settings_positions_path
      else
        render :edit
      end
    end
  end
end
