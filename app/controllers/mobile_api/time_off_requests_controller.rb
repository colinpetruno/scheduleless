module MobileApi
  class TimeOffRequestsController < ApiAuthenticatedController
    def index
      @time_off_requests = policy_scope(TimeOffRequest)

      render json: {
        time_off_requests: TimeOffRequestsPresenter.for(@time_off_requests)
      }, status: :ok
    end

    def create
      @request = TimeOffRequest.new(time_off_request_params)

      authorize @request

      if @request.save
        render json: {
          time_off_request: TimeOffRequestPresenter.for(@request)
        }, status: :ok
      else
        render json: { errors: @request.errors }, status: :bad_request
      end
    end
  end
end
