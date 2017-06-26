class TimeOffRequestsController < AuthenticatedController
  def create
    @request = TimeOffRequest.new(time_off_request_params)

    authorize @request

    if @request.save
      redirect_to time_off_requests_path
    else
      render :new
    end
  end

  def index
    @time_off_requests = policy_scope(TimeOffRequest)
  end

  def new
    authorize :time_off_request, :new?

    @request = TimeOffRequest.new
  end

  private

  def time_off_request_params
    params.
      require(:time_off_request).
      permit(
        :end_date_string,
        :end_minutes,
        :start_date_string,
        :start_minutes
      ).merge(
        user_id: current_user.id
      )
  end
end
