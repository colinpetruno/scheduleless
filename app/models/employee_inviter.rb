class EmployeeInviter
  attr_reader :user

  def self.for(user_params)
    new(user_params: user_params)
  end

  def initialize(location: nil, user_params:)
    @location = location
    @user_params = user_params
  end

  def send
    @user = User.invite!(user_params)

    add_location if location.present?

    user.persisted?
  end

  private

  attr_reader :location, :user_params

  def add_location
    UserLocation.create(location_id: location.id, user_id: user.id)
  end
end
