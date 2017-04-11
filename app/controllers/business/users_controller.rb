module Business
  class UsersController < AuthenticatedController
    def edit
      @user = current_company.users.find(params[:id])
      authorize @user
    end

    def index
      @users = policy_scope(User)
    end

    def show
      @user = current_company.users.find(params[:id])
      authorize @user
    end

    def update
      @user = current_company.users.find(params[:id])
      authorize @user

      if @user.update(user_params)
        redirect_to business_users_path
      else
        # todo
      end
    end

    def user_params
      params.
        require(:user).
        permit(:email, position_ids: [])

    end
  end
end
