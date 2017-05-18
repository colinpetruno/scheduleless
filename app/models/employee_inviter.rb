class EmployeeInviter
  attr_reader :user

  def self.for(user_params)
    new(user_params: user_params)
  end

  def initialize(user_params:)
    @user_params = user_params
  end

  def send
    @user = User.invite!(user_params)

    user.persisted?
  end

  private

  attr_reader :user_params
end
