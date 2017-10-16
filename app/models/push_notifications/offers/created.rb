module PushNotifications
  module Offers
    class Created < Base
      def initialize(user:, offer:)
        @user = user
        @offer = offer
      end

      def message
        I18n.t("models.push_notifications.#{translation_key}.message",
               user_name: offer.user.full_name)
      end

      private

      attr_reader :user, :trade

      def translation_key
        "offers.created"
      end
    end
  end
end
