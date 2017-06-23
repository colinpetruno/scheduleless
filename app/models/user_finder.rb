class UserFinder
  def initialize(location: nil, user: nil)
    @location = location
    @user = user
  end

  def admins_for_location
    company = location.company

    position_ids = company.
      positions.
      where("company_admin = ? or location_admin = ?", true, true).
      pluck(:id)

    company.
      users.
      joins(:user_locations).
      where(primary_position_id: position_ids,
            user_locations: { location_id: location.id })
  end

  def by_associated_locations
    User.
      joins(:user_locations).
      where(company: user.company).
      where(user_locations: { location_id: user.locations }).
      where.not(user_locations: { user_id: user.id })
  end

  def by_company_without_current_user
    user.company.users.where.not(id: user.id)
  end

  def by_location_without(user)
    location.
      users.
      where.
      not(user_locations: { user_id: user.id }).
      order(:family_name, :given_name)
  end

  def company_admins
    company = location.company
    position_ids = company.positions.where(company_admin: true).pluck(:id)

    company.
      users.
      joins(:user_locations).
      where(primary_position_id: position_ids,
            user_locations: { location_id: location.id })
  end

  def location_admins
    company = location.company
    position_ids = company.positions.where(location_admin: true).pluck(:id)

    company.
      users.
      joins(:user_locations).
      where(primary_position_id: position_ids,
            user_locations: { location_id: location.id })
  end

  private

  attr_reader :location, :user
end
