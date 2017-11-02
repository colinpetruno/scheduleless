module Remote
  module Dashboard
    class TimeOffApprovalsController < AuthenticatedController
      def create
        approval = TimeOffRequests::Approval.new(time_off_requests_approval_params)

        authorize approval

        @status = approval.execute
        if @status
          redirect_to(dashboard_path,
            notice: I18n.t("time_off_requests.approvals.controller.success")
          )
        else
          redirect_to(dashboard_path,
            notice: I18n.t("time_off_requests.approvals.controller.failure")
          )
        end
      end

      private

      def time_off_request
        TimeOffRequest.find(params[:time_off_request_id])
      end

      def time_off_requests_approval_params
        params.
          require(:time_off_requests_approval).
          permit(:accept).
          merge(
            reviewer: current_user,
            time_off_request: time_off_request
          )
      end
    end
  end
end
