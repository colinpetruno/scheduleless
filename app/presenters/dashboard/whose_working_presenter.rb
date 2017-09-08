module Dashboard
  class WhoseWorkingPresenter
    attr_reader :locations

    def initialize(locations)
      @locations = locations
    end

    def closing_time_for(location)
      location_hours_for(location).closing
    end

    def location_partial_for(location)
      if location_hours_for(location).open?
        "dashboards/whose_working/location_open"
      else
        "dashboards/whose_working/location_closed"
      end
    end

    def next_event_line_for(location)
      # TODO: Localize
      if location_hours_for(location).open?
        "Closes at #{closing_time_for(location)}"
      else
        "Opens on #{opening_time_for(location)}"
      end
    end

    def opening_time_for(location)
      location_hours_for(location).opening
    end

    private

    def build_location_hour_map
      locations.inject({}) do |map, location|
        map[location.id] = LocationHours.for(location)
        map
      end
    end

    def location_hours_for(location)
      location_hour_map[location.id]
    rescue
      LocationHours.for(location)
    end

    def location_hour_map
      @_location_hour_map ||= build_location_hour_map
    end

  end
end
