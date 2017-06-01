class Registration
  include ActiveModel::Model

  validate :email_unique?
  validate :passwords_match?
  validates :company_name, presence: true
  validates :email, presence: true, length: { minimum: 3, maximum: 200 }
  validates :password, presence: true
  validates :password_confirmation, presence: true

  attr_accessor :company_name, :email, :password, :password_confirmation

  def company
    user.company
  end

  def register
    user if valid?
  end

  def user
    @_user ||= User.create(user_params)
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

  def email_unique?
    if User.where(email: email).present?
      errors.add(:email, I18n.t("onboarding.registrations.model.email_taken"))
    end
  end

  def passwords_match?
    if password != password_confirmation
      errors.add(:password,
                 I18n.t("onboarding.registrations.model.password_confirmation")
                )
      errors.add(:password_confirmation,
                 I18n.t("onboarding.registrations.model.password_confirmation")
                )
    end
  end

  def user_params
    {
      company_admin: true,
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      company_attributes: {
        name: company_name
      }
    }
  end
end
