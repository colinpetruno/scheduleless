module Notifications
  module Offers
    class CreatedJob < ApplicationJob
      def perform(offer_id)
        @offer = Offer.find(offer_id)

        user_to_alert = offer.trade.user

        begin
          PushNotifications::Offers::Created.
            new(user: user_to_alert, offer: offer).
            notify

          if Users::Emailable.for(trade.user)
            NotificationsMailer.
              new_offer(user, offer).
              deliver
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

