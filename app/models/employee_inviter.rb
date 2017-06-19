class EmployeeInviter
  attr_reader :user

  def self.for(user_params)
    new(user_params: user_params)
  end

  def initialize(location: nil, notify_now: false, user_params:)
    @location = location
    @notify_now = notify_now
    @user_params = user_params
  end

  def send
    if notify_now
      @user = User.invite!(user_params)
    else
      @user = User.invite!(user_params) do |u|
        u.skip_invitation = true
      end
    end

    add_location if location.present?

    user.persisted?
  end

  private

  attr_reader :location, :notify_now, :user_params

  def add_location
    UserLocation.create(location_id: location.id, user_id: user.id)
  end
end
