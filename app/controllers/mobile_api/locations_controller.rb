module MobileApi
  class LocationsController < ApiAuthenticatedController
    def index
      @locations = policy_scope(Location)

      render json: { locations: @locations }, status: :ok
    end
  end
end
