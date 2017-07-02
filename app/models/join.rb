class Join
  include ActiveModel::Model

  validate :email_unique?
  validates :email, presence: true, length: { minimum: 3, maximum: 200 }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile_phone, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :passwords_match?
  validates_format_of :password,
    with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/,
    message: "must include one number, one letter and be between 8 and 40 characters"

  attr_accessor :location_id, :email, :first_name, :last_name, :mobile_phone,
    :password, :password_confirmation, :user

  def process
    if valid?
      ActiveRecord::Base.transaction do
        self.user = User.create(user_params)
        UserLocation.create(user_location_params)
      end

      EmployeeJoinedLocationJob.perform_later(self.user.id, location_id)
    else
      false
    end
  rescue StandardError => error
    Bugsnag.notify(error)
    false
  end

  private

  def company
    location.company
  end

  def email_unique?
    if User.where(email: email).present?
      errors.add(:email, I18n.t("onboarding.registrations.model.email_taken"))
    end
  end

  def location
    Location.find(location_id)
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

  def user_location_params
    {
      location_id: location.id,
      user_id: self.user.id
    }
  end

  def user_params
    {
      company_id: company.id,
      email: email,
      family_name: last_name,
      given_name: first_name,
      mobile_phone: mobile_phone,
      password: password,
      password_confirmation: password_confirmation
    }
  end
end
