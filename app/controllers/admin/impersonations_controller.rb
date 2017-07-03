module Admin
  class ImpersonationsController < AdminController
    def new
      @impersonation = Impersonation.new
    end

    def create
      impersonation = Impersonation.create!(impersonation_params)

      original_user = current_user
      new_user = User.find impersonation.impersonated_user_id

      sign_in(:user, new_user)
      redirect_to default_calendar_path_for(new_user)
    end

    private

    def impersonation_params
      params.
        require(:impersonation).
        permit(:impersonated_user_id).
        merge(user_id: current_user.id)
    end
  end
end
