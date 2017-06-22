class Registration
  include ActiveModel::Model

  validate :email_unique?
  validate :passwords_match?
  validates :company_name, presence: true
  validates :email, presence: true, length: { minimum: 3, maximum: 200 }
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates_format_of :password,
    with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/,
    message: "must include one number, one letter and be between 8 and 40 characters"

  attr_accessor :company_name, :email, :first_name, :last_name,
    :password, :password_confirmation

  def company
    user.company
  end

  def register
    user if valid?
  end

  def user
    @_user ||= create_user
  end

  private

  def create_payment_account
    customer.
      subscriptions.
      create(plan: company.subscription.plan)

    customer
  end

  def create_user
    user = User.new(user_params)
    user.save(validate: false)
    user
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
      family_name: last_name,
      given_name: first_name,
      password: password,
      password_confirmation: password_confirmation,
      company_attributes: {
        name: company_name
      }
    }
  end
end
