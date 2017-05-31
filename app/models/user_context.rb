class UserContext
   attr_reader :user, :location

  def initialize(location: nil, user:)
    @location = location
    @user = user
  end
end
