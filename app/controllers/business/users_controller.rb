module Business
  class UsersController < AuthenticatedController
    def create
      authorize User

      employee_inviter = EmployeeInviter.for(user_params)

      if employee_inviter.send
        redirect_to business_users_path
      else
        # TODO handle errors
      end
    end

    def edit
      @user = current_company.users.find(params[:id])
      authorize @user
    end

    def index
      @users = policy_scope(User).order(:family_name, :given_name)
    end

    def new
      @user = current_company.users.build
      authorize @user
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
        permit(:email,
               :family_name,
               :given_name,
               :mobile_phone,
               position_ids: []).
        merge({ company_id: current_company.id })

    end
  end
end
