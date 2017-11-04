module Business
  module Employees
    class WagesController < AuthenticatedController
      def show
        @user = User.find(params[:user_id])
        authorize @user, :edit?
      end
    end
  end
end
