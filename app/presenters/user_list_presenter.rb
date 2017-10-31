class UserListPresenter
  # this class is used to prevent n+1 in user lists
  attr_reader :users

  def self.for(users)
    new(users: users)
  end

  def initialize(users:)
    @users = users
  end

  def invitation_state_for(user)
    Users::InvitationState.
      new(user: user, login_user: login_user_for(user)).
      state
  end

  def login_user_for(user)
    login_user_lookup.find(user)
  end

  def position_name_for(user)
    position_map[user.primary_position_id].name
  rescue
    "N/A"
  end

  private

  def login_user_lookup
    @_login_user_lookup ||= Users::LoginUserLookup.for(users)
  end

  def position_map
    @_position_map ||= Position.
      where(id: users.map(&:primary_position_id)).
      inject({}) do |hash, position|
        hash[position.id] = position
        hash
      end
  end

end
