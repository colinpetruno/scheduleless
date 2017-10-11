module ScheduleMailers
  class ScheduleUpdatedPresenter
    attr_reader :user, :notifications

    def initialize(user:, notifications:)
      @user = user
      @notifications = notifications
    end

    def messsage_key
      if notifications.length > 1
        :multiple_changes
      else
        notifications.first.to_s
      end
    end
  end
end
