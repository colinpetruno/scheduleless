module Business
  module Employees
    class CoworkabilitiesController < AuthenticatedController
      def show
        authorize :coworkability, :show?
        @user = current_company.users.find(params[:user_id])

        @presenter = Business::Employees::CoworkabilityShowPresenter.
          new(user: @user)
      end
    end
  end
end
