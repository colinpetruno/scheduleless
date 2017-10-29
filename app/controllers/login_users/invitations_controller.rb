class LoginUsers::InvitationsController < Devise::InvitationsController
  def update_resource_params
    params.
      require(:login_user).
      permit(:invitation_token,
             :password,
             :password_confirmation,
             user_attributes: [
               :id,
               :family_name,
               :given_name,
               :mobile_phone,
             ])
  end
end
