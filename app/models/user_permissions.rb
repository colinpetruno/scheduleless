class UserPermissions
  def self.for(user)
    new(user: user)
  end

  def initialize(user:)
    @user = user
  end

  def company_admin?
    user.company_admin? || positions.where(company_admin: true).present?
  end

  def location_admin?
    positions.where(location_admin: true).present?
  end

  def scheduleless_admin?
    user.scheduleless_admin?
  end

  def manage?(object)
    if object.is_a? Location
      manage_location?(object)
    elsif  object.is_a? User
      manage_user?(object)
    end
  end

  private

  attr_reader :user

  def locations
    user.locations
  end

  def manage_location?(location)
    positions.where(location_admin: true).present? && locations.include?(location)
  end

  def manage_user?(user)
    if company_admin?
      true
    elsif location_admin?
      UserLocation.exists?(user_id: user.id, location_id: locations.pluck(:id))
    else
      false
    end
  end

  def positions
    user.positions
  end
end
