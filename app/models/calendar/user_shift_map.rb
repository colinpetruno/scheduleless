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

    private

    attr_reader :shifts

    def build_shift_map
      shifts.each do |shift|
        shift_map[shift.user_id] = [] unless shift_map[shift.user.id].present?
        shift_map[shift.user_id].push(shift)
      end
    end

    def shift_map
      @_shift_map ||= {}
    end
  end
end
