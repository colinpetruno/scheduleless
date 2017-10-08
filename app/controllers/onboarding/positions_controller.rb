module Onboarding
  class PositionsController < BaseController
    layout "onboarding"

    def create
      @position = current_company.
        positions.
        build(permitted_attributes(Position))

      authorize @position

      if @position.save
        Onboarding::Status.for(current_company).move_to_next_step!(5)
        if current_user.primary_position_id.blank?
          current_user.update(primary_position_id: @position.id)
        end

        redirect_to new_onboarding_position_path
      else
        render :new
      end
    end

    def destroy
      @position = current_company.positions.find(params[:id])

      authorize @position

      if @position.update_columns(deleted_at: DateTime.now)
        # TODO: update onboarding if its the last position and now we need to
        # go back and ensure the user hits here
        redirect_to new_onboarding_position_path
      else
        # TODO ERROR
      end
    end

    def new
      @position = current_company.
        positions.
        build

      authorize @position
    end
  end
end
