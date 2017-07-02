class InvitationSender
  attr_reader :user

  def self.for(user)
    new(user: user)
  end

  def initialize(user:)
    @user = user
  end

  def send
    Chewy.strategy(:atomic) do
      user.invite!
    end

    # token can only be called after invite! and needs set before generating
    # the url
    self.token = user.raw_invitation_token
    send_mobile_invite if user.mobile_phone.present?

    true
  rescue StandardError => error
    Bugsnag.notify(error)
    false
  end

  private

  attr_accessor :token

  def host
    # TODO: look into a better way to get this, if we update where we store
    # assets down the line we could hit issues with this mailer
    Rails.application.config.action_mailer.asset_host
  end

  def message
    url = signup_url(source: "sms")
    Rails.logger.info("Send SMS Invite: Url Is: #{url}")

    <<~MESSAGE
      You have been invited by #{user.company.name} to join Scheduleless. In
      order to receive and manage your schedule, click the link to complete
      your registration. #{signup_url(source: "sms")}
    MESSAGE
  end

  def routes
    Rails.application.routes.url_helpers
  end

  def send_mobile_invite
    SmsMessage.new(message: message, user: user).send
  end

  def signup_url(source: "email")
    routes.accept_user_invitation_url(
      invitation_token: token,
      host: host,
      source: source
    )
  end
end
