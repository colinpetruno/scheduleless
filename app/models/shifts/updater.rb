module Shifts
  class Updater
    def self.for(in_progress_shift)
      new(in_progress_shift)
    end

    def initialize(in_progress_shift)
      @in_progress_shift = in_progress_shift
    end

    def update(params = {})
      record_changes(params)

      ActiveRecord::Base.transaction do
        in_progress_shift.update(params).merge(edited: true)

        if in_progress_shift.published?
          Shift.
            where(in_progress_shift_id: in_progress_shift.id).
            update_all(minute_start: in_progress_shift.minute_start,
                       minute_end: in_progress_shift.minute_end,
                       date: in_progress_shift.date,
                       location_id: in_progress_shift.location_id,
                       user_id: in_progress_shift.user_id)
          # need to notify the published person their shift changed
        end
      end

      # do this outside the transaction so it happens if the transaction block
      # is successful, prevents queuing jobs and then having the transaction
      # roll back
      if in_progress_shift.published? && needs_notification?
        # TODO: add proper notifications queueing here
        puts "NOTIFICATIONS WILL GET QUEUED HERE"
      end
    rescue StandardError => error
      Bugsnag.notify(error)
      false
    end

    private

    attr_reader :in_progress_shift

    def needs_notifications?
      @user_changed || @time_changed || @date_changed
    end

    def record_changes(params)
      if params[:user_id].present? && in_progress_shift.user_id != params[:user_id]
        @original_user = in_progress_shift.user_id
        @new_user = params[:user_id]
        @user_changed = true
      end

      if params[:minute_start].present? &&
          in_progress_shift.minute_start != params[:minute_start]
        @time_changed = true
      end

      if params[:minute_end].present? &&
          in_progress_shift.minute_end != params[:minute_end]
        @time_changed = true
      end

      if params[:date].present? &&
          in_progress_shift.user_id != params[:date]
        @date_changed = true
      end
    end
  end
end
