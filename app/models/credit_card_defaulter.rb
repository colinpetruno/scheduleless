class CreditCardDefaulter
  def self.for(credit_card)
    new(credit_card: credit_card)
  end

  def initialize(credit_card:)
    @credit_card = credit_card
  end

  def update
    # update this in stripe
    stripe_customer.stripe_object.default_source = credit_card.token
    stripe_customer.stripe_object.save

    # get new stripe customer
    stripe_customer.reload
    # see if they match
    if stripe_customer.stripe_object.default_source == credit_card.token
      # update all cards to false
      company.credit_cards.find_by(default: true).update(default: false)
      # update this card to default true
      credit_card.update(default: true)

      true
    else
      # TODO: raise some error here or add errors somewhere, see controller
      #
      false
    end
  end

  private

  attr_reader :credit_card

  def company
    credit_card.company
  end

  def stripe_customer
    @_stripe_customer ||= StripeCustomer.for(company)
  end
end
