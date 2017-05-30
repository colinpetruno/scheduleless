class SmsMessage
  include ActionView::Helpers::NumberHelper

  def initialize(message:, user:)
    @message = message
    @user = user
  end

  def send
    client.messages.create(
      from: Rails.application.secrets.twilio_from_number,
      to: formatted_phone,
      body: message
    )
  end

  def formatted_phone
    number_to_phone(user.mobile_phone, delimiter: "", country_code: "1")
  end

  private

  attr_reader :message, :user

  def client
    @_client ||= Twilio::REST::Client.new
  end
end
