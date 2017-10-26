class UnsubscribesController < ApplicationController
  layout "blank"

  def show
  end

  def update
    @user = User.unscoped.find_by!(hash_key: params[:uuid])
    @user.notification_preference.update!(global_unsubscribe: true)
  end
end
