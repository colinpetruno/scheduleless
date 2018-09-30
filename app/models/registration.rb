class Registration
  include ActiveModel::Model

  validates :company_name, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, length: { minimum: 3, maximum: 200 }
  validate :email_unique?
  validates :password, presence: true
  validates_format_of :password,
    with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/,
    message: "must include one number, one letter and be between 8 and 40 characters"

  attr_accessor :company_name, :email, :first_name, :last_name, :password,
                :plan_id, :request

  def company
    @_company || create_company
  end

  def register
    return false if spammer?

    ActiveRecord::Base.transaction do
      create_company
      create_user # makes company again?
      create_subscription
    end

    # TODO: Background...
    StripeCustomer.for(company).create
    StripeSubscription.for(subscription).create

    begin
      NewCustomerJob.perform_later(user.user.id)
    rescue StandardError => error
      Bugsnag.notify(error)
    end

    if user.persisted?
      begin
        if Rails.application.secrets.deliver_support_mailers
          # login user here
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

  def default_location
    @_default_location ||= company.locations.first
  end

  def create_company
    @_company = Company.create(
      name: company_name,
      locations_attributes: [{
        name: "My Default Location"
      }]
    )
  end

  def create_subscription
    @_subscription = Subscription.create(company: company, plan: plan)
  end

  def create_user
    # binding.pry
    @_user = LoginUser.create(
      email: email,
      password: password,
      password_confirmation: password,
      user_attributes: {
        company_admin: true,
        company_id: company.id,
        email: email,
        family_name: last_name,
        given_name: first_name,
      }
    )

    company_user = User.find_by!(company_id: company.id,
                                 login_user_id: @_user.id)

    UserLocation.create(user_id: company_user.id,
                        location_id: default_location.id,
                        home: true,
                        admin: true
                       )
  end

  def email_unique?
    if LoginUser.where(email: email).present?
      errors.add(:email, I18n.t("onboarding.registrations.model.email_taken"))
    end
  end

  def plan
    if plan_id.present?
      Plan.find(plan_id)
    else
      begin
        Plan.find_by!(default: true)
      rescue ActiveRecord::RecordNotFound
        Plan.create(plan_name: "Standard", default: true)
      end
    end
  end

  def spammer?
    count = LoginUser.
      where(last_sign_in_ip: request.ip, created_at: ((DateTime.now - 4.minutes)..DateTime.now)).
      size

    return count >= 3
  rescue StandardError => error
    Bugsnag.notify(error)

    false
  end

  def subscription
    @_subscription ||= create_subscription
  end
end
