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
        exp_month: stripe_credit_card.exp_month,
        exp_year: stripe_credit_card.exp_year,
        last_4: stripe_credit_card.last4
      )

    stripe_credit_card
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
      stripe_customer.sources.retrieve(credit_card.token)
    else
      stripe_customer.sources.create(source: credit_card.token)
    end
  end

  def stripe_customer
    @_stripe_customer ||= StripeCustomer.for(credit_card.company).retrieve
  end
end
