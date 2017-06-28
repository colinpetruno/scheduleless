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
        status: time_off_request.status.capitalize,
        background_color: background_color,
        border_color: border_color,
        text_color: text_color
      }
    end

    private

    attr_reader :time_off_request

    def background_color
      colors = {
        approved: "#dff0d8",
        pending: "#e9f1ff",
        denied: "#fbe8cd"
      }

      colors[time_off_request.status.to_sym]
    end

    def border_color
      colors = {
        approved: "#b2dba1",
        pending: "#c5d9ff",
        denied: "#f6ce95"
      }

      colors[time_off_request.status.to_sym]
    end

    def text_color
      colors = {
        approved: "#529138",
        pending: "#5f97ff",
        denied: "#c77c11"
      }

      colors[time_off_request.status.to_sym]
    end
  end
end
