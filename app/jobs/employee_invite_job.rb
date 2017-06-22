class EmployeeInviteJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)

    InvitationSender.for(@user).send
  end
end
