module InProgressShifts
  class DeleteConfirmation
    include ActiveModel::Conversion
    attr_reader :in_progress_shift_id, :delete_series

    def self.for(in_progress_shift)
      new(in_progress_shift: in_progress_shift)
    end

    def initialize(params = {})
      @in_progress_shift_id = params[:in_progress_shift_id]
      @delete_series = params[:delete_series]
    end

    def model_name
      ActiveModel::Name.new(self.class)
    end

    def persisted?
      false
    end

    def process
      ActiveRecord::Base.transaction do
        in_progress_shift.update(deleted_at: DateTime.now, edited: true)

        if in_progress_shift.repeating? && delete_series == "1"
          InProgressShift.
            where(repeating_shift_id: in_progress_shift.repeating_shift_id,
                  edited: true).
            update_all(deleted_at: DateTime.now)

          in_progress_shift.
            repeating_shift.
            update(preview_deleted_at: DateTime.now)
        end
      end

      send_notification

      true
    rescue StandardError => error
      Bugsnag.notify(error)
      false
    end

    def in_progress_shift
      @in_progress_shift ||= InProgressShift.find(in_progress_shift_id)
    end

    private

    def send_notification
      # STOP  since this cant be published right away no need to notify at
      # this point
    end
  end
end
