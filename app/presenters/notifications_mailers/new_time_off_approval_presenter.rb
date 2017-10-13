module NotificationsMailers
  class NewTimeOffApprovalPresenter
    def initialize(time_off_request)
      @time_off_request = time_off_request
    end

    def time_label
      time_off_request.label
    end

    def requestee
      time_off_request.user.full_name
    rescue
      "An Employee"
    end

    private

    attr_reader :time_off_request
  end
end
