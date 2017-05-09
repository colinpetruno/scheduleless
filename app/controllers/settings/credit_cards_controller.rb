module Settings
  class CreditCardsController < AuthenticatedController
    def index
      @credit_cards = policy_scope(CreditCard)
    end

    def new
      @credit_card = current_company.credit_cards.build

      authorize @credit_card
    end
  end
end
