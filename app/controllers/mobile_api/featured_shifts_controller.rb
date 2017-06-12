module MobileApi
  class FeaturedShiftsController
    def show
      render json: FeaturedShift.for(current_user)
    end
  end
end
