module MobileApi
  class CheckOutsController < ApiAuthenticatedController
    def create
      check_out = CheckOut.for(shift)

      authorize check_out

      if check_out.check_out
        render json: {
          featured_shift: FeaturedShift.for(current_user)
        }, status: :ok
      else
        render json: { errors: check_out.errors }, status: :bad_request
      end
    end

    private

    def shift
      current_user.shifts.find(params[:shift_id])
    end
  end
end
