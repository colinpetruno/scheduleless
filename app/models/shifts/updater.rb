module Shifts
  class Updater
    def self.update(in_progress_shift, params, publish=false)
      new(in_progress_shift, params, publish).update
    end

    def initialize(in_progress_shift, params={}, publish=false)
      @in_progress_shift = in_progress_shift
      @params = params
      @publish = publish
    end

    def update
      # in the event of a shift that was modified but not published immediately
      # then a user comes back and edits it to publish it but not make a change
      # this prevents the publish from happening. I like the optimization and
      # we should TODO: try to add it back
      # return true if not_changed?

      ActiveRecord::Base.transaction do
        if in_progress_shift.repeating?
          if params[:update_repeating_rule] == "all"
            update_all_repeating_shifts
          else
            update_single_repeating_shift
          end
        else
          in_progress_shift.update(@params.merge(edited: true))

          if publish?
            publish_shift(in_progress_shift)
          end
        end
      end
    rescue StandardError => error
      Bugsnag.notify(error)
      false
    end

    private

    attr_reader :in_progress_shift, :params

    def not_changed?
      # assign the attributes and use dirty attributes to see if there was any
      # changes to the model. If not then we can just skip this record
      # because the user didn't actually change any data
      in_progress_shift.assign_attributes(@params)
      changed = in_progress_shift.changed?

      # ensure we revert all changes to the in_progress_shift
      in_progress_shift.restore_attributes
      !changed
    end

    def publish?
      @publish
    end

    def repeating_shift
      in_progress_shift.repeating_shift
    end

    def repeating_shift_id
      in_progress_shift.repeating_shift_id
    end

    def update_all_repeating_shifts
      repeating_shift.update(preview_minute_end: params[:minute_end],
                             preview_minute_start: params[:minute_start],
                             preview_user_id: params[:user_id])


      if publish?
        Shifts::Publishers::RepeatingShift.
          new(repeating_shift: repeating_shift).
          publish
      else
        InProgressShift.
          where(repeating_shift_id: repeating_shift_id).
          update_all(edited: true,
                     minute_end: params[:minute_end],
                     minute_start: params[:minute_start],
                     user_id: params[:user_id])
      end
    end

    def update_single_repeating_shift
      in_progress_shift.update(deleted_at: DateTime.now)
      new_shift = InProgressShift.create(@params.merge(edited: true))

      if publish?
        publish_shift(new_shift)
      end
    end

    def publish_shift(shift)
      Shifts::Publishers::SingleShift.
        new(in_progress_shift: shift).
        publish
    end
  end
end
