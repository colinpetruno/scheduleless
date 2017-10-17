module Shifts
  class RepeatingShiftsPopulator
    def initialize(end_date: Date.today,
                   location: nil,
                   start_date: Date.today,
                   user: nil)
      @end_date = end_date
      @location = location
      @start_date = start_date
      @user = user

      if location.blank? && user.blank?
        raise StandardError.new("Requires a user or location")
      end
    end

    def populate
      repeating_shifts.each do |repeating_shift|
        (start_date..end_date).each do |date|
          # ensure we only populate if its past the repeating shift start date
          next if date.to_s(:integer).to_i < repeating_shift.start_date.to_i

          if multiple_of?(repeating_shift, date)
            create_shift(repeating_shift, date)
          end
        end
      end
    end

    private

    attr_reader :end_date, :location, :start_date, :user

    def company
      location.company
    end

    def create_shift(repeating_shift, date)
      # TODO: Fix N+1, this class can be made quite a bit faster. For every
      # repeating shift we need to create we are seeing if it exists. We
      # should pull out the in_progress repeating shifts into an array and then
      # detect in that array to avoid many sql queries.

      # ensure we check to make sure it wasn't previously populated and deleted
      in_progress_shift = InProgressShift.
        unscoped.
        find_or_initialize_by(
          company_id: company.id,
          date: date.to_s(:integer),
          location_id: location.id,
          repeating_shift_id: repeating_shift.id,
          user_id: repeating_shift.preview_user_id
        ) do |ips|
          ips.minute_end = repeating_shift.preview_minute_end
          ips.minute_start = repeating_shift.preview_minute_start
          ips.position_id = repeating_shift.position_id
        end

      if repeating_shift.published? && in_progress_shift.new_record?
        in_progress_shift.edited = false
        in_progress_shift.published = true
        in_progress_shift.save

        Publishers::Utilities::ShiftCreator.create_from(in_progress_shift)
      elsif repeating_shift.published?
        #TODO what?
      else
        in_progress_shift.save
      end
    end

    def multiple_of?(repeating_shift, date)
      shift_date = Date.parse(repeating_shift.start_date.to_s)

      (date - shift_date).to_i % repeating_shift.repeat_frequency == 0
    end

    def options
      {
        location_id: location.try(:id),
        user_id: user.try(:id)
      }.delete_if { |key, value| value.blank? }
    end

    def repeating_shifts
      RepeatingShift.where(preview_deleted_at: nil).where(options)
    end
  end
end
