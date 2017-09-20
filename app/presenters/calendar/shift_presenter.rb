module Calendar
  class ShiftPresenter
    def initialize(shift:, manage: false, day_start: 0)
      @day_start = day_start
      @manage = manage
      @shift = shift
    end

    def classes
      array = ["shift", "length-#{shift_length.to_i}", "start-#{start_offset}"]
      array.push("edited") if shift.edited?

      array.reject(&:blank?).join(" ")
    end

    def delete_url
      routes.
        new_remote_in_progress_shifts_in_progress_shift_delete_confirmation_path(
          shift
        )
    end

    def details_url
      if shift.is_a? InProgressShift
        routes.edit_remote_location_in_progress_shift_path(shift.location, shift)
      else
        routes.remote_calendar_shift_shift_detail_path(shift)
      end
    end

    def favorite_url
      routes.
        new_remote_calendar_location_favorite_shift_path(
          shift.location,
          favorite_shift: {
            position_id: shift&.user&.primary_position_id,
            start_minute: shift.minute_start,
            end_minute: shift.minute_end
          }
        )
    end

    def repeat_url
      if repeating?
        routes.
          edit_remote_calendar_location_repeating_shift_path(shift.location_id,
                                                             shift.repeating_shift_id)
      else
        routes.
          new_remote_calendar_location_repeating_shift_path(
            shift.location,
            repeating_shift: {
              in_progress_shift_id: shift.id,
              location_id: shift.location_id,
              minute_end: shift.minute_end,
              minute_start: shift.minute_start,
              start_date: shift.date,
              user_id: shift.user_id
            }
          )
      end
    end

    def time_range
      DateAndTime::ShiftDateTime.for(shift).time_range
    end

    def position
      shift.user.primary_position.name
    rescue
      ""
    end

    def repeating?
      shift.repeating_shift_id.present?
    end

    def user
      shift.user
    end

    def user_id
      shift.user_id
    end

    private

    attr_reader :day_start, :manage, :shift

    def routes
      Rails.application.routes.url_helpers
    end

    def shift_length
      DateAndTime::ShiftDateTime.for(shift).length_in_minutes
    end

    def start_offset
      puts "DAY START IS #{day_start}"
      shift.minute_start - day_start
    end
  end
end
