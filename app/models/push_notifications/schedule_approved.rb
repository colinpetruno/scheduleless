module PushNotifications
  class ScheduleApproved < Base
    def initialize(user:, scheduling_period:)
      @scheduling_period = scheduling_period
      @user = user
    end
  end
end
