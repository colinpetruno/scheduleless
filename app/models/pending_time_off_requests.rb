class PendingTimeOffRequests
  def initialize(user:)
    @user = user
  end

  def approve?
    if user.company_admin? || user.location_admin?
      true
    else
      false
    end
  end

  def waiting_approval
    if user.company_admin?
      TimeOffRequest.
        joins(:user).
        where(status: :pending, users: { company_id: user.company_id })
    else
      TimeOffRequest.
        joins("INNER JOIN user_locations on user_locations.user_id = time_off_requests.user_id").
        where(status: :pending, user_locations: { location_id: user_location_ids })
    end
  end

  private

  attr_reader :user

  def user_location_ids
    user.locations.pluck(:id)
  end
end
