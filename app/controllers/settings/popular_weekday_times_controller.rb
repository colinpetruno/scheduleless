module Settings
  class PopularWeekdayTimesController < AuthenticatedController
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
        build(type: "PopularWeekdayTime",
              level: "busy",
              time_start: 450,
              time_end: 900)
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
