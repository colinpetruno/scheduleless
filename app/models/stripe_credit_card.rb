class StripeCreditCard
  def self.for(credit_card)
    new(credit_card: credit_card)
  end

  def initialize(credit_card:)
    @credit_card = credit_card
  end

  def create
    # assign is important here, update will cause before_create to fire again
    credit_card.
      assign_attributes(
        brand: stripe_credit_card.brand,
        default: default_card?,
        exp_month: stripe_credit_card.exp_month,
        exp_year: stripe_credit_card.exp_year,
        last_4: stripe_credit_card.last4,
        stripe_card_id: stripe_credit_card.id
      )

    stripe_credit_card
  end

  def delete
    # TODO: check api call return
    stripe_credit_card.delete
  end

  def retrieve
    stripe_credit_card
  end

  def stripe_credit_card
    @_stripe_credit_card ||= find_credit_card
  end

  private

  attr_reader :credit_card

  def find_credit_card
    if credit_card.persisted?
      stripe_customer.stripe_object.sources.retrieve(credit_card.stripe_card_id)
    else
      stripe_customer.stripe_object.sources.create(source: credit_card.token)
    end
  end

  def default_card?
    stripe_customer.reload.stripe_object.default_source == stripe_credit_card.id
  end

  def stripe_customer
    @_stripe_customer ||= StripeCustomer.for(credit_card.company)
  end
end
