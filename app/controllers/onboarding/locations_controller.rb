module Onboarding
  class LocationsController < BaseController
    layout "onboarding"

    def index
      @locations = policy_scope(Location)
    end

    def edit
      @location = current_company.locations.find(params[:id])

      authorize @location

      Onboarding::Status.for(current_company).move_to_next_step!(2)
    end

    def new
      # can skip previous step so need to set this on landing here
      Onboarding::Status.for(current_company).move_to_next_step!(2)
      # TODO: NOTICE APPEARING ON ADD EMPLOYEE SCREEN
      @location = Location.new

      authorize @location
    end

    def create
      @location = current_user.locations.build(location_params)

      authorize @location

      if current_user.save
        # skipping step 3
        Onboarding::Status.for(current_company).move_to_next_step!(4)
        redirect_to new_onboarding_position_path
      else
        render :new
      end
    end

    def update
      @location = current_company.locations.find(params[:id])
      authorize @location

      if @location.update(location_params)
        redirect_to new_onboarding_position_path
      else
        render :edit
      end
    end

    private

    def location_params
      params.
        require(:location).
        permit(:additional_details, :city, :county_province,
               :line_1, :line_2, :line_3, :name, :postalcode, :time_zone).
        merge(company: current_company)
    end
  end
end
