module Reporting
  class LocationsController < BaseController
    def index
      @locations = policy_scope(Location)
    end
  end
end
