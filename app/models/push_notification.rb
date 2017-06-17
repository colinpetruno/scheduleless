class PushNotification
  def initialize(adapter: FCM, message:, recipient:, title:)
    @adapter = adapter
    @message = message
    @recipient = recipient
    @title = title
  end

  def send
    if push_enabled?
      client.send(tokens, notification_hash)
    else
      true
    end
  end

  private

  attr_reader :adapter, :message, :recipient, :title

  def api_key
    Rails.application.secrets.firebase_key
  end

  def client
    @_client ||= adapter.new(api_key)
  end

  def notification_hash
    {
      notification: {
        title: title,
        body: message
      }
    }
  end

  def push_enabled?
    if Rails.application.secrets.push_enabled == "true"
      true
    else
      false
    end
  end

  def tokens
    recipient.firebase_tokens.pluck(:token)
  end
end
