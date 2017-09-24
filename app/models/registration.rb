class Registration
  include ActiveModel::Model

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, length: { minimum: 3, maximum: 200 }
  validate :email_unique?
  validates :password, presence: true
  validates_format_of :password,
    with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/,
    message: "must include one number, one letter and be between 8 and 40 characters"

  attr_accessor :email, :first_name, :last_name, :password, :plan_id

  def company
    @_company || create_company
  end

  def register
    ActiveRecord::Base.transaction do
      create_company
      create_user # makes company again?
      create_subscription
    end

    # TODO: Background...
    StripeCustomer.for(company).create
    StripeSubscription.for(subscription).create

    if user.persisted?
      begin
        if Rails.application.secrets.deliver_support_mailers
          SupportMailer.new_signup(user).deliver
        end
      rescue StandardError => error
        Bugsnag.notify(error)
        Bugsnag.notify("New Sign Up - Support Email Failed To Send")
      end
      true
    else
      false
    end
  end

  def user
    @_user ||= create_user
  end

  private

  def create_company
    @_company = Company.create(name: "My Company Name")
  end

  def create_subscription
    @_subscription = Subscription.create(company: company, plan: plan)
  end

  def create_user
    @_user = User.create(
      company_admin: true,
      company_id: company.id,
      email: email,
      family_name: last_name,
      given_name: first_name,
      password: password,
      password_confirmation: password
    )
  end

  def email_unique?
    if User.where(email: email).present?
      errors.add(:email, I18n.t("onboarding.registrations.model.email_taken"))
    end
  end

  def plan
    if plan_id.present?
      Plan.find(plan_id)
    else
      Plan.find_by!(default: true)
    end
  end

  def subscription
    @_subscription ||= create_subscription
  end
end
