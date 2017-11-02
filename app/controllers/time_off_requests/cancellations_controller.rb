module TimeOffRequests
  class CancellationsController < AuthenticatedController

    def update
      authorize time_off_request
      time_off_request.status = :canceled

      if time_off_request.save
        redirect_to time_off_requests_path
      else
        # TODO: Error
      end
    end

    private

    def time_off_request
      @_time_off_request ||= TimeOffRequest.find(params[:time_off_request_id])
    end

  end
end
