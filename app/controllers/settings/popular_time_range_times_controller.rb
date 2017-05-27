module Settings
  class PopularTimeRangeTimesController < AuthenticatedController
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
        build(type: "PopularTimeRangeTime",
              level: "busy",
              time_start: 600,
              time_end: 1200)
    end

    private

    def popular_time_params
      params.
        require(:popular_time_range_time).
        permit(
          :day_end,
          :day_start,
          :holiday_name,
          :level,
          :time_end,
          :time_start,
          :type
        )
    end
  end
end
