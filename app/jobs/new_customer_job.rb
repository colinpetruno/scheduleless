class NewCustomerJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    @user = LoginUser.find(user_id).user

    if Users::Emailable.for(@user)
      WelcomeDripMailer.welcome(@user).deliver
    end
  end
end
