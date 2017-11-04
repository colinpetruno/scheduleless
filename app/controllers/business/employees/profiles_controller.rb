module Business
  module Employees
    class ProfilesController < AuthenticatedController
      def show
        @user = current_company.users.find(params[:user_id])

        authorize @user
      end
    end
  end
end
