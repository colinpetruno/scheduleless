module Shifts
  class Transferer
    def initialize(new_user:, shift:)
      @new_user = new_user
      @shift = shift
    end

    def transfer
      # binding.pry
      ActiveRecord::Base.transaction do
        shift.update(state: :traded)
        shift.in_progress_shift.update(deleted_at: DateTime.now)
        Shift.create(new_shift_attributes)
      end
    end

    private

    attr_reader :new_user, :old_user, :shift

    def in_progress_shift
      @_in_progress_shift ||= InProgressShift.create(in_progress_attributes)
    end

    def new_shift_attributes
      base_shift_attributes.merge(in_progress_shift_id: in_progress_shift.id)
    end

    def in_progress_attributes
      base_shift_attributes.merge({ edited: false, published: true })
    end

    def base_shift_attributes
      # note this will never be a repeating shift for now so we do not want
      # to pull over the repeating shift ids
      shift.
        attributes.
        slice("company_id", "minute_start", "minute_end", "date", "location_id").
        merge({ user_id: new_user.id })
    end
  end
end
