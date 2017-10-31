module Users
  class LoginUserLookup
    def self.for(users)
      new(users: users)
    end

    def initialize(users:)
      @users = users
    end

    def find(user)
      login_user_map[user.login_user_id]
    end

    private

    attr_reader :users

    def login_user_map
      @_login_user_map ||= LoginUser.where(id: users.map(&:login_user_id)).inject({}) do |hash, user|
        hash[user.id] = user
        hash
      end
    end
  end
end
