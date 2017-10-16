module PushNotifications
  module Trades
    class Completed < Base
      def initialize(user:, trade:)
        @user = user
        @trade = trade
      end

      def message
        I18n.t("models.push_notifications.#{translation_key}.message")
      end

      private

      attr_reader :user, :trade

      def translation_key
        "trades.approved"
      end
    end
  end
end
