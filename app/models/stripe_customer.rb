class StripeCustomer
  def self.for(company)
    new(company: company)
  end

  def initialize(company:)
    @company = company
  end

  def create
    @customer ||= find_customer
  end

  def retrieve
    @customer ||= find_customer
  end

  def reload
    @customer = find_customer
    self
  end

  def stripe_object
    @customer ||= find_customer
  end

  private

  attr_reader :company, :customer

  def find_customer
    if company.stripe_customer_id.present?
      retrieve_customer
    else
      create_customer
    end
  end

  def create_customer
    stripe_customer = Stripe::Customer.create(description: company.name)

    company.update(stripe_customer_id: stripe_customer.id)

    stripe_customer
  end

  def retrieve_customer
    Stripe::Customer.retrieve(company.stripe_customer_id)
  end
end
