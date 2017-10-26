class NewCustomerJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)

    if Users::Emailable.for(@user)
      WelcomeDripMailer.welcome(@user).deliver
    end
  end
end
