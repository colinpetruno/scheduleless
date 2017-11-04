module Remote
  module Employees
    class PositionsController < AuthenticatedController
      def update
        @user = current_company.users.find(params[:user_id])
        authorize @user

        # TODO: Report_ids causes n+1 update query
        @user.update(user_params)
      end

      private

      def user_params
        params.
          require(:user).
          permit(:primary_position_id,
                 :primary_location_id,
                 :manager_id,
                 :employee_status,
                 :start_date,
                 position_ids: [],
                 location_ids: [],
                 report_ids: []
                )
      end
    end
  end
end
