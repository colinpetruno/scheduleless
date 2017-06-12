module MobileApi
  class CheckInsController < ApiAuthenticatedController
    def create
      check_in_creator = CheckInCreator.for(shift)

      authorize check_in_creator.check_in

      if check_in_creator.save
        render json: {
          featured_shift: FeaturedShift.for(current_user)
        }, status: :ok
      else
        render json: { errors: check_in_creator.check_in.errors }, status: :bad_request
      end
    end
  end
end
