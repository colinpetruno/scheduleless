class Registration
  include ActiveModel::Model

  attr_accessor :company_params, :user_params

  def company
    user.company
  end

  def errors
    user.errors
  end

  def register
    user.valid?
  end

  def user
    @_user ||= User.create(user_params.merge(company_admin: true))
  end

  private

  def create_payment_account
    customer.
      subscriptions.
      create(plan: company.subscription.plan)

    customer
  end

  def customer
    @_customer ||= Stripe::Customer.create(
      description: company.name
    )
  end
end
