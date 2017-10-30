class NewCustomerJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    # TODO: Update this to use LoginUser instead of user
    @user = User.find(user_id)

    if Users::Emailable.for(@user)
      WelcomeDripMailer.welcome(@user).deliver
    end
  end
end
