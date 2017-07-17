module Reporting
  class ReportingParams
    include ActiveModel::Model

    attr_reader :location, :date_start, :date_end

    def self.for(location, date_start, date_end)
      new(location: location, date_start: date_start, date_end: date_end)
    end

    def initialize(location:, date_start:, date_end:)
      @location = location
      @date_start = date_start
      @date_end = date_end
    end

    def location
      @location
    end

    def date_start
      @date_start
    end

    def date_end
      @date_end
    end
  end
end
