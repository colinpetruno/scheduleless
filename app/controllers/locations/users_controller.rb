module Locations
  class UsersController < AuthenticatedController
    def index
      skip_policy_scope
      @location = current_company.locations.find(params[:location_id])

    end
  end
end
