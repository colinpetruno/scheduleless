class Users::InvitationsController < Devise::InvitationsController

  def update_resource_params
    params.
      require(:user).
      permit(:family_name,
             :given_name,
             :invitation_token,
             :mobile_phone,
             :password,
             :password_confirmation)
  end
end
