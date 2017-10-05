module Remote
  module Dashboard
    class TimeOffApprovalsController < AuthenticatedController
      def create
        approval = TimeOffRequests::Approval.new(time_off_requests_approval_params)

        authorize approval

        @status = approval.execute
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
