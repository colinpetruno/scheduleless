module MobileApi
  class FirebaseTokensController < ApiAuthenticatedController
    def create
      firebase_token = FirebaseToken.new(firebase_token_params)

      if firebase_token.save
        render json: { firebase_token: firebase_token }, status: :ok
      else
        render json: { errors: firebase_token.errors }, status: :bad_request
      end
    end

    private

    def firebase_token_params
      params.
        require(:firebase_token).
        permit(:token).
        merge(user_id: current_user.id)
    end
  end
end
