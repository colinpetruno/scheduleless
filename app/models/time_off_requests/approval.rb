module TimeOffRequests
  class Approval
    include ActiveModel::Model

    attr_accessor :accept, :reviewer, :time_off_request

    def execute
      if accept == "true"
        time_off_request.
          update_columns(status: :approved, reviewed_by: reviewer.id)

        Notifications::TimeOffRequests::ApprovedJob.perform_later(time_off_request.id)
      else
        time_off_request.
          update_columns(status: :denied, reviewed_by: reviewer.id)

        Notifications::TimeOffRequests::DeniedJob.perform_later(time_off_request.id)
      end

      true
    rescue StandardError => error
      Bugsnag.notify(error)
      false
    end

    def user
      time_off_request.user
    end
  end
end
