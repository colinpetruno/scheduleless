module PushNotifications
  module Trades
    class Approval < Base
      def initialize(user:, trade:)
        @user = user
        @trade = trade
      end

      def message
        I18n.t("models.push_notifications.#{translation_key}.message",
               user_name: trade.user.full_name)
      end

      private

      attr_reader :user, :trade

      def translation_key
        "trades.approval"
      end
    end
  end
end
