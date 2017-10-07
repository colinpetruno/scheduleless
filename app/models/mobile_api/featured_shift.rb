module MobileApi
  class FeaturedShift
    def self.for(user)
      new(user: user)
    end

    def initialize(user:)
      @user = user
    end

    def as_json(_options={})
      ShiftPresenter.for(shift_to_display).as_json(checked_in: true)
    end

    private

    attr_reader :user

    def shift_to_display
      checked_in_shift || current_shift || next_shift || raise_not_found
    end

    def checked_in_shift
      @_checked_in_shift ||= Shifts::Finder.for(user).checked_in.find
    end

    def current_shift
      @_checked_in_shift ||= Shifts::Finder.for(user).current.find.first
    end

    def next_shift
      @_next_shift ||= Shifts::Finder.for(user).next.find
    end

    def raise_not_found
      raise ActiveRecord::RecordNotFound
    end
  end
end
