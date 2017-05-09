module Settings
  class SubscriptionsController < AuthenticatedController
    def edit
      @subscription = current_company.subscription

      authorize @subscription
    end

    def update
    end
  end
end
