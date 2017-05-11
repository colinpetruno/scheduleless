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
        redirect_to settings_path
      else
        # TODO: show errors
      end
    end

    private

    def subscription_params
      params.require(:subscription).permit(:plan)
    end
  end
end
