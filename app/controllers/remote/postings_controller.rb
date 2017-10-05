module Remote
  class PostingsController < AuthenticatedController
    helper_method :presenter_class

    def create
      @location = current_company.locations.find(params[:location_id])
      @posting = @location.postings.create(posting_params)

      authorize @posting

      Shifts::Publishers::DateRange.
        new(end_date: @posting.date_end,
            location: @location,
            start_date: @posting.date_start).
        publish
    end

    def new
      @location = current_company.locations.find(params[:location_id])
      @posting = @location.
        postings.
        build(new_posting_params)

      authorize @posting
    end

    private

    def new_posting_params
      start_date = begin
         Date.parse(params[:date_start]).to_s
      rescue
        nil
      end

      end_date = begin
         Date.parse(params[:date_end]).to_s
      rescue
        nil
      end

      { date_start: start_date, date_end: end_date }
    end

    def presenter_class
      if view == "daily"
        ::Calendar::DailySchedulePreviewPresenter
      else
        ::Calendar::WeeklySchedulePresenter
      end
    end

    def posting_params
      params.
        require(:posting).
        permit(:all_shifts, :date_start, :date_end).
        merge(user_id: current_user.id)
    end

    def view
      cookies[:view] = params[:view] || cookies[:view] ||  "weekly"

      cookies[:view]
    end
  end
end
