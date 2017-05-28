module Settings
  class PopularDateRangeTimesController < AuthenticatedController
    def create
      authorize PopularTime

      @period = current_company.popular_times.build(popular_time_params)

      if @period.save
        redirect_to settings_popular_times_path
      else
        render :new
      end
    end

    def destroy
      authorize PopularTime, :update?

      @period = current_company.popular_times.find(params[:id])

      if @period.destroy
        redirect_to settings_popular_times_path
      else
        redirect_to settings_popular_times_path, alert: "We could not delete your range at this time"
      end
    end

    def edit
      authorize PopularTime, :edit?

      @period = current_company.popular_times.find(params[:id])
    end

    def new
      authorize PopularTime, :new?
      @period = current_company.
        popular_times.
        build(type: "PopularDateRangeTime",
              day_end_day: 10,
              day_end_month: 6,
              level: "busy"
             )
    end

    def update
      authorize PopularTime, :update?

      @period = current_company.popular_times.find(params[:id])

      if @period.update(popular_time_params)
        redirect_to settings_popular_times_path
      else
        render :edit
      end
    end

    private

    def popular_time_params
      params.
        require(:popular_date_range_time).
        permit(
          :day_end_day,
          :day_end_month,
          :day_start_day,
          :day_start_month,
          :level,
          :type
        )
    end
  end
end
