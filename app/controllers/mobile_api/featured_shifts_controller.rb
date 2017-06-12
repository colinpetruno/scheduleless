module MobileApi
  class FeaturedShiftsController
    def show
      render json: {
        featured_shift: FeaturedShift.for(current_user)
      }
    end
  end
end
