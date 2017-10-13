module Remote
  class InProgressShiftsController < AuthenticatedController
    helper_method :presenter_class

    def create
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.build(in_progress_shift_params)

      authorize @shift

      ActiveRecord::Base.transaction do
        # using a transaction here to ensure that the shift is only created
        # if the publish also succeeds
        @shift.save

        if @shift.persisted? && publish?
          Shifts::Publishers::SingleShift.
            new(in_progress_shift: @shift, notify: true).
            publish
        end
      end
    end

    def edit
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.find(params[:id])

      authorize @shift
    end

    def new
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.build(shift_get_params)

      authorize @shift
    end

    def update
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.find(params[:id])

      authorize @shift

      Shifts::Updater.update(@shift, in_progress_shift_params)
    end

    private

    def presenter_class
      if view == "daily"
        ::Calendar::DailySchedulePreviewPresenter
      else
        ::Calendar::WeeklySchedulePresenter
      end
    end

    def view
      cookies[:view] = params[:view] || cookies[:view] ||  "weekly"

      cookies[:view]
    end

    def in_progress_shift_params
      params.
        require(:in_progress_shift).
        permit(:date,
               :minute_end,
               :minute_start,
               :position_id,
               :repeat_frequency,
               :update_repeating_rule,
               :user_id).
        merge(company_id: current_company.id,
              location_id: params[:location_id])
    end

    def publish?
      params[:commit] == I18n.t("remote.in_progress_shifts.form.create_and_publish")
    end

    def shift_get_params
      shift_param_hash = { date: params[:date] }
      shift_param_hash.merge!(user_id: user.id) if user.present?
      shift_param_hash.merge!(position_id: user.primary_position_id) if user.present?
      shift_param_hash
    end

    def user
      current_company.users.find(params[:user_id])
    rescue
      nil
    end
  end
end
