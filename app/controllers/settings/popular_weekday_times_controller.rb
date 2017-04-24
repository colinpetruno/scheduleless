module Settings
  class PopularWeekdayTimesController < AuthenticatedController
    def create
      authorize PopularTime

      @period = current_company.popular_times.build(popular_time_params)

      if @period.save
        redirect_to settings_popular_times_path
      else
        #TODO fix this error
      end
    end

    private

    def popular_time_params
      params.
        require(:popular_weekday_time).
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
