module MobileApi
  class FeaturesController < ApiAuthenticatedController
    def index
      skip_policy_scope

      render json: {
        features: Features.for(current_company).as_json
      }, status: :ok
    end
  end
end
