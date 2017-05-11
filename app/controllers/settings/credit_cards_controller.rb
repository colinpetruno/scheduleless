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

    def destroy
      # TODO: we probably want a soft delete here
      credit_card = current_company.
        credit_cards.
        where(default: false).
        find(params[:id])

      authorize credit_card

      if CreditCardDeleter.for(credit_card).delete
        redirect_to settings_credit_cards_path
      else
        # TODO: I hate error handling
      end
    end

    def index
      @credit_cards = policy_scope(CreditCard)
    end

    def new
      @credit_card = current_company.credit_cards.build

      authorize @credit_card
    end

    def update
      # only thing that change here is the default value
      credit_card = current_company.credit_cards.find(params[:id])

      authorize credit_card

      if CreditCardDefaulter.for(credit_card).update
        redirect_to settings_credit_cards_path
      else
        # ruh-roh what TODO
      end
    end

    private

    def credit_card_params
      params.require(:credit_card).permit(:token, :default)
    end
  end
end
