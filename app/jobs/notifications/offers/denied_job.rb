module Notifications
  module Offers
    class DeniedJob < ApplicationJob
      def perform(offer_id)
        @offer = Offer.find(offer_id)
        @trade = @offer.trade

        begin
          [@offer.user, @trade.user].each do |user|
            PushNotifications::Offers::Denied.
              new(user: user, trade: @trade).
              notify

            if Users::Emailable.for(user)
              NotificationsMailer.
                trade_denied(user, @trade, @offer).
                deliver
            end
          end
        rescue StandardError => error
          Bugsnag.notify(error)
        end
      end

      private

      attr_reader :offer
    end
  end
end
