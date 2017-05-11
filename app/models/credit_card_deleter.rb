class CreditCardDeleter
  def self.for(credit_card)
    new(credit_card: credit_card)
  end

  def initialize(credit_card:)
    @credit_card = credit_card
  end

  def delete
    StripeCreditCard.for(credit_card).delete
    credit_card.destroy

    true
  rescue
    # TODO: Log Error
    false
  end

  private

  attr_reader :credit_card

  def stripe_customer
    @_stripe_customer = StripeCustomer.for(credit_card.company)
  end
end
