module Users
  class InvitationState
    def initialize(user:, login_user: nil)
      @login_user = login_user
      @user = user
    end

    def readable_state
      # TODO: I18n
      state.to_s.humanize
    end

    def state
      if user.email.blank?
        return :uninvitable
      end

      if user.login_user_id.blank?
        :awaiting_invite
      elsif login_user.accepted_or_not_invited?
        if login_user.sign_in_count > 0 || login_user.invitation_accepted_at.present?
          :active
        else
          :awaiting_invite
        end
      else
        :invited
      end
    end

    private

    attr_reader :user

    def login_user
      @login_user ||= user.login_user
    end
  end
end
