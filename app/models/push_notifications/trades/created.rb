module PushNotifications
  module Trades
    class Created < Base
      def initialize(user:, trade:)
        @user = user
        @trade = trade
      end

      def message
        I18n.t("models.push_notifications.#{translation_key}.message",
               user_name: trade.user.full_name,
               dates: trade.shift.selection_label)
      end

      private

      attr_reader :user, :trade

      def translation_key
        "trades.created"
      end
    end
  end
end
