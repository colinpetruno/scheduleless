module Settings
  class ConfirmDeletesController < AuthenticatedController
    def destroy
      authorize(:position, :destroy?)
      @delete_confirmation = ConfirmDelete.new(confirm_delete_params)

      if @delete_confirmation.delete_with_associations
        redirect_to(settings_positions_path,
          notice: I18n.t("#{translate_base}.successful"))
      else
        @position = position
        render :show
      end
    end

    def show
      authorize(:position, :destroy?)

      @position = position
      @delete_confirmation = ConfirmDelete.new(position: @position)

      if @delete_confirmation.deletable?
        delete_and_redirect(@delete_confirmation)
      end
    end

    private

    def translate_base
      "settings.confirm_deletes.controller"
    end

    def confirm_delete_params
      params.
        require(:confirm_delete).
        permit(:delete_positions, :delete_rules, :new_position_id,
               :new_rule_id).
        merge(position: position)
    end

    def delete_and_redirect(delete_confirmation)
      delete_confirmation.delete

      redirect_to(settings_positions_path,
          notice: I18n.t("#{translate_base}.successful")) and return
    end

    def position
      current_company.positions.find(params[:position_id])
    end
  end
end
