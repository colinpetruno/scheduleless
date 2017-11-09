class User < ApplicationRecord
  include EmailValidatable
  include NotDeletable

  belongs_to :company
  belongs_to :login_user
  belongs_to :manager, class_name: "User"
  belongs_to :primary_location, class_name: "Location"
  belongs_to :primary_position, class_name: "Position"

  has_many :firebase_tokens
  has_many :employee_positions
  has_many :in_progress_shifts
  has_many :leads
  has_many :user_locations
  has_many :locations, through: :user_locations
  has_many :positions, through: :employee_positions
  has_many :preferred_hours, dependent: :destroy
  has_many :reports, class_name: "User", foreign_key: "manager_id"
  has_many :shifts
  has_many :trades

  has_one :notification_preference

  default_scope { where(deleted_at: nil) }

  validates :email,
            allow_blank: true,
            email: true,
            length: { minimum: 3, maximum: 200 },
            uniqueness: true

  validates :family_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :given_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :mobile_phone, allow_blank: true, length: { minimum: 7, maximum: 30 }
  validates :locale, inclusion: { in: LocaleOptions.valid_locales }
  validates :wage, allow_blank: true, inclusion: { in: (0..9999), message: "must be between 0 and 9999" }

  accepts_nested_attributes_for :company, :leads, :preferred_hours

  before_create :build_availabilities
  before_save :check_for_blank_email
  before_save :convert_wage_to_cents

  attr_accessor :salary_amount, :wage

  enum employee_status: {
    active: 0,
    terminated: 1
  }

  enum employment_type: {
    full_time: 0,
    part_time: 1,
    temp: 2
  }

  enum exemption_status: {
    non_exempt: 0,
    exempt: 1
  }

  enum legal_gender: {
    male: 0,
    female: 1
  }

  update_index "site_search#user", :self

  def self.employee_status_options
    # TODO: I18n
    employee_statuses.keys.map do |status|
      [I18n.t("models.user.employee_statuses.#{status}"), status]
    end
  end

  def self.exemption_status_options
    exemption_statuses.keys.map do |status|
      [I18n.t("models.user.exemption_status.#{status}"), status]
    end
  end

  def self.legal_gender_options
    # TODO: I18n
    legal_genders.keys.map { |g| [g.humanize, g] }
  end

  def self.employment_type_options
    employment_types.keys.map { |g| [g.humanize, g] }
  end

  def as_json(_options={})
    super(only: [:email, :id, :given_name, :family_name, :preferred_name])
  end

  def compensation_type
    # TODO: I18n
    if salary
      "Salary"
    else
      "Hourly"
    end
  end

  def coworkability_access
    # need to see if they are a company admin or someone that gets notified
    # in case of incidents or can speicially see it via a field?
    true
  end

  def hash_key
    super || generate_hash_key
  end

  def login_user
    super || backfill_login_user
  end

  def notification_preference
    super || create_notification_preference
  end

  def salary_amount
    if @salary_amount.present?
      @salary_amount.to_f
    else
      formatted_salary_amount
    end
  end

  def wage
    if @wage.present?
      @wage.to_f
    else
      formatted_wage
    end
  end

  def display_wage
    sprintf "%.2f", wage
  end

  def invitation_state
    Users::InvitationState.new(user: self).state
  end

  def manage?(location)
    warn "[DEPRECATION] `manage?` is deprecated.  Please use `UserPermission` instead."
    positions.where(location_admin: true).present? && locations.include?(location)
  end

  def deliver_invitation(options = {})
    super # send email through devise invitable
    # send twilio
  end

  def full_name
    [given_name, family_name].compact.join(" ")
  end

  def twilio_formatted_phone
  end

  def formatted_salary_amount(wage=nil)
    # TODO: these should be handled by the currency input
    if salary_amount_cents.present?
      (salary_amount_cents/100.00).to_f
    end
  end

  def formatted_wage(wage=nil)
    if wage_cents.present?
      (wage_cents/100.00).to_f
    end
  end

  private

  def convert_wage_to_cents
    if wage.blank?
      self.wage_cents = nil
    else
      self.wage_cents = wage.to_f*100
    end

    if salary_amount.blank?
      self.salary_amount_cents = nil
    else
      self.salary_amount_cents = salary_amount.to_f*100
    end
  end

  def backfill_login_user
    # need to ensure this can be made without a password so they can get
    # invited
    if self.email.present?
      begin
        login = LoginUser.new(email: self.email, password: "")
        login.save(validate: false)
        self.update(login_user_id: login.id)

        login
      rescue StandardError => error
        Bugsnag.notify(error)
        nil
      end
    end
  end

  def build_availabilities
    PreferredHour.build_for(self)
  end

  def check_for_blank_email
    if self.email.blank?
      self.email = nil
    end
  end

  # override devise method so it performs our validation instead
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def generate_hash_key
    key = SecureRandom.hex(22)

    if self.persisted?
      update_column(:hash_key, key)
    else
      self.hash_key = key
    end

    key
  end
end
