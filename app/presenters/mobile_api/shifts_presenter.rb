module MobileApi
  class ShiftsPresenter
    def self.for(shifts)
      new(shifts: shifts)
    end

    def initialize(shifts:)
      @shifts = shifts
    end

    def as_json(_options={})
      shifts.map do |shift|
        ShiftPresenter.for(shift).as_json
      end
    end

    private

    attr_reader :shifts
  end
end
