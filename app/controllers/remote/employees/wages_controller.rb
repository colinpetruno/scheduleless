module Remote
  module Employees
    class WagesController < AuthenticatedController
      def update
        @user = current_company.users.find(params[:user_id])
        authorize @user

        @user.update(user_params)
      end

      private

      def user_params
        params.
          require(:user).
          permit(:employment_type,
                 :salary,
                 :salary_amount,
                 :wage,
                 :performs_exempt_duties,
                 :exemption_status)
      end
    end
  end
end
