module MobileApi
  class TimeOffRequestPresenter
    def self.for(time_off_request)
      new(time_off_request: time_off_request)
    end

    def initialize(time_off_request:)
      @time_off_request = time_off_request
    end

    def as_json(_options={})
      {
        id: time_off_request.id,
        label: time_off_request.label,
        status: time_off_request.status,
        status_color: status_color
      }
    end

    private

    attr_reader :time_off_request

    def status_color
      colors = {
        approved: "#b2dba1", # dff0d8 #529138
        pending: "#c5d9ff", # 5f97ff
        denied: "#f6ce95" # #fbe8cd; # c77c11
      }

      colors[time_off_request.status.to_sym]
    end
  end
end
