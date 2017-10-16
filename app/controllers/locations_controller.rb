class LocationsController < AuthenticatedController
  def create
    @location = current_company.locations.build(location_params)

    authorize @location

    if @location.save
      # add the user creating it to the location
      UserLocation.create(user: current_user, location: @location)

      redirect_to locations_path
    else
      render :new
    end
  end

  def edit
    @location = current_company.locations.find(params[:id])
    authorize @location
  end

  def index
    @locations = policy_scope(Location)
  end

  def new
    @location = current_company.locations.build
    authorize @location
  end

  def show
    @location = current_company.locations.find(params[:id])
    authorize @location
  end

  def update
    @location = current_company.locations.find(params[:id])
    authorize @location

    if @location.update(location_params)
      redirect_to redirect_url(@location)
    else
      render :edit
    end
  end

  private

  def location_params
    params.
      require(:location).
      permit(:city,
             :county_province,
             :country,
             :line_1,
             :line_2,
             :line_3,
             :name,
             :postalcode,
             :time_zone,
             :use_custom_scheduling_rules,
             preference_attributes: [
               :break_length,
               :id,
               :maximum_shift_length,
               :preferred_shift_length,
               :minimum_shift_length,
               :preferable_id,
               :preferable_type,
               :shift_overlap,
               :use_company_settings
             ]
            ).
      merge(company: current_company)
  end

  def redirect_url(location)
    if request.referrer.include?("schedule_rules")
      locations_location_schedule_rules_path(location)
    else
      edit_location_path(location)
    end
  end
end
