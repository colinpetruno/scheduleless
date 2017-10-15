class CancelShiftNotificationJob < ApplicationJob
  def perform(shift_id)
    @shift = Shift.find(shift_id)

    users.map do |user|
      PushNotifications::CancelledShift.new(user: user, shift: @shift).notify
      # TODO: Send email
    end
  end

  private


  def location
    @shift.location
  end

  def users
    user_finder.admins_for_location
  end

  def user_finder
    @_user_finder ||= UserFinder.new(location: location)
  end
end
