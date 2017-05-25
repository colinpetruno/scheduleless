module Settings
  class SubscriptionsController < AuthenticatedController
    def edit
      @subscription = current_company.subscription

      authorize @subscription
    end

    def update
      subscription = current_company.subscription

      authorize subscription

      if SubscriptionUpdater.for(subscription).update(subscription_params)
        redirect_to edit_settings_subscription_path,
          notice: I18n.t("settings.subscriptions.controller.notice")
      else
        redirect_to edit_settings_subscription_path,
          alert: I18n.t("settings.subscriptions.controller.alert")
      end
    end

    private

    def subscription_params
      params.require(:subscription).permit(:plan)
    end
  end
end
