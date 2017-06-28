module MobileApi
  class TimeOffRequestsPresenter
    def self.for(time_off_requests)
      new(time_off_requests: time_off_requests)
    end

    def initialize(time_off_requests:)
      @time_off_requests = time_off_requests
    end

    def as_json(_options={})
      time_off_requests.map do |time_off_request|
        TimeOffRequestPresenter.for(time_off_request).as_json
      end
    end

    private

    attr_reader :time_off_requests
  end
end
