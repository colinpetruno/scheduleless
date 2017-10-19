module Notifications
  module Offers
    class AcceptedJob < ApplicationJob
      def perform(offer_id)
        @offer = Offer.find(offer_id)
        @trade = @offer.trade
        @location = @trade.location

        preferences = PreferenceFinder.for(@location)

        begin
          if preferences.approve_trades?
            managers_to_notify.each do |user|
              PushNotifications::Trades::Approval.
                new(user: user, trade: @trade).
                notify

              if Users::Emailable.for(user)
                NotificationsMailer.
                  new_trade_approval(user, @trade, @offer).
                  deliver
              end
            end

            [@offer.user, @trade.user].each do |user|
              PushNotifications::Trades::AwaitingApproval.
                new(user: user, trade: @trade).
                notify

              if Users::Emailable.for(user)
                NotificationsMailer.
                  trade_awaiting_approval(user, @trade, @offer).
                  deliver
              end
            end
          else # offer can be directly accepted
            [@offer.user, @trade.user].each do |user|
              PushNotifications::Trades::Completed.
                new(user: user, trade: @trade).
                notify


              if Users::Emailable.for(user)
                NotificationsMailer.
                  trade_completed(user, @trade, @offer).
                  deliver
              end
            end
          end
        rescue StandardError => error
          Bugsnag.notify(error)
        end
      end

      private

      attr_reader :offer

      def managers_to_notify
        UserFinder.new(location: @location).location_admins
      end
    end
  end
end
