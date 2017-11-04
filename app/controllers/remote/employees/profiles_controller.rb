module Remote
  module Employees
    class ProfilesController < AuthenticatedController
      def update
        @user = current_company.users.find(params[:user_id])
        authorize @user

        @user.update(user_params)
      end

      private

      def user_params
        params.
          require(:user).
          permit(:date_of_birth,
                 :email,
                 :family_name,
                 :given_name,
                 :legal_gender,
                 :mobile_phone,
                 :preferred_name,
                 :work_phone)
      end
    end
  end
end
