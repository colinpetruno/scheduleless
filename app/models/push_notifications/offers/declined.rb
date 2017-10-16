module PushNotifications
  module Offers
    class Declined < Base
      def initialize(user:, offer:)
        @user = user
        @offer = offer
      end

      def message
        I18n.t("models.push_notifications.#{translation_key}.message",
               dates: offer.trade.shift.selection_label)
      end

      private

      attr_reader :user, :trade

      def translation_key
        "offers.declined"
      end
    end
  end
end
