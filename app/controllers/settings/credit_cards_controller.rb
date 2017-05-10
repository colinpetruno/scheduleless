module Settings
  class CreditCardsController < AuthenticatedController
    def create
      @credit_card = current_company.credit_cards.build(credit_card_params)

      authorize @credit_card

      if @credit_card.save
        redirect_to settings_path
      else
        # TODO: SHOW ERROR
      end
    end

    def index
      @credit_cards = policy_scope(CreditCard)
    end

    def new
      @credit_card = current_company.credit_cards.build

      authorize @credit_card
    end

    private

    def credit_card_params
      params.require(:credit_card).permit(:token)
    end
  end
end
