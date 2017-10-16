module Notifications
  module Trades
    class CreatedJob < ApplicationJob
      def perform(trade_id)
        @trade = Trade.find(trade_id)

        users_to_alert.map do |user|
          begin
            PushNotifications::Trades::Created.
              new(user: user, trade: trade).
              notify

            if Users::Emailable.for(trade.user)
              NotificationsMailer.
                new_trade(user, trade).
                deliver
            end
          rescue StandardError => error
            Bugsnag.notify(error)
          end
        end
      end

      private

      attr_reader :trade

      def location
        trade.location
      end

      def users_to_alert
        UserFinder.
          new(location: location).
          by_location_without(trade.user)
      end
    end
  end
end
