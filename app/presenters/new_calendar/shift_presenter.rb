module NewCalendar
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

    def details_url
      if shift.is_a? InProgressShift
        routes.edit_remote_location_in_progress_shift_path(shift.location, shift)
      else
        routes.remote_new_calendar_shift_shift_detail_path(shift)
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
