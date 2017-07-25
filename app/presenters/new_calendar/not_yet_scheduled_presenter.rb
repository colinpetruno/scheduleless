module NewCalendar
  class NotYetScheduledPresenter
    attr_reader :location

    def initialize(date: Date.today, location:, user:)
      @date = date
      @location = location
      @user = user
    end

    def date_string
      date.to_s(:integer)
    end

    def manage?
      UserPermissions.for(user).manage?(location)
    end

    private

    attr_reader :date, :user
  end
end
