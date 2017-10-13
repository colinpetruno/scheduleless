class EmployeeInviter
  attr_accessor :user

  def self.for(user_params)
    new(user_params: user_params)
  end

  def initialize(location: nil, notify_now: false, user_params:)
    @location = location
    @notify_now = notify_now
    @user_params = user_params
  end

  def send
    return false if invalid?

    if notify_now && inviteable?
      self.user = User.invite!(user_params)
    else
      self.user = User.new(user_params)
      user.save(validate: false)
    end

    add_location if location.present? && user.persisted?

    user.persisted?
  end

  private

  attr_reader :location, :notify_now, :user_params

  def add_location
    UserLocation.create(location_id: location.id, user_id: user.id)
  end

  def invalid?
    # this is super ugly but am circumventing email uniqueness and manully
    # need to validate this object
    if user_params[:given_name].blank? || user_params[:family_name].blank? || user_params[:primary_position_id].blank?
      self.user = User.new(user_params)
      self.user.errors.add(:given_name, :blank) if user_params[:given_name].blank?
      self.user.errors.add(:family_name, :blank) if user_params[:family_name].blank?
      self.user.errors.add(:primary_position_id, :blank) if user_params[:primary_position_id].blank?

      true
    else
      false
    end
  end

  def inviteable?
    user_params[:email].present?
  end
end
