module MobileApi
  class FeaturedShiftsController < ApiAuthenticatedController
    def show
      render json: {
        featured_shift: FeaturedShift.for(current_user)
      }
    end
  end
end
