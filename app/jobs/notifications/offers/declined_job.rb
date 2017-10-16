module Notifications
  module Offers
    class DeclinedJob < ApplicationJob
      def perform(offer_id)
        @offer = Offer.find(offer_id)

        begin
          PushNotifications::Offers::Declined.
            new(user: offer.user, offer: offer).
            notify

          if Users::Emailable.for(offer.user)
            NotificationsMailer.
              offer_declined(offer.user, offer).
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
