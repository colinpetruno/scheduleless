module MobileApi
  class CheckOutsController < ApiAuthenticatedController
    def create
      check_out = CheckOut.for(shift)

      authorize check_out

      if check_out.check_out
        render json: { check_out: check_out.check_in }, status: :ok
      else
        render json: { errors: check_out.errors }, status: :bad_request
      end
    end
  end
end
