module Calendar
  class UserShiftMap
    def self.for(shifts)
      new(shifts: shifts)
    end

    def initialize(shifts:)
      @shifts = shifts
      build_shift_map
      self
    end

    def by(user)
      user_shifts = shift_map[user.id]

      if user_shifts.present?
        user_shifts
      else
        []
      end
    end

    def unassigned
      shift_map["unassigned"] || []
    end

    private

    attr_reader :shifts

    def build_shift_map
      shifts.each do |shift|
        shift_key = shift&.user&.id || "unassigned"

        shift_map[shift_key] = [] unless shift_map[shift_key].present?
        shift_map[shift_key].push(shift)
      end
    end

    def shift_map
      @_shift_map ||= {}
    end
  end
end
