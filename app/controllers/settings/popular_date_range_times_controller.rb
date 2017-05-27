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
