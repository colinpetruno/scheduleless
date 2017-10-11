class User < ApplicationRecord
  include NotDeletable

  belongs_to :company
  belongs_to :primary_position, class_name: "Position"

  has_many :firebase_tokens
  has_many :employee_positions
  has_many :in_progress_shifts
  has_many :leads
  has_many :user_locations
  has_many :locations, through: :user_locations
  has_many :positions, through: :employee_positions
  has_many :preferred_hours, dependent: :destroy
  has_many :shifts
  has_many :trades

  default_scope { where(deleted_at: nil) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email,
            allow_blank: true,
            length: { minimum: 3, maximum: 200 },
            uniqueness: true

  validates :family_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :given_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :mobile_phone, allow_blank: true, length: { minimum: 7, maximum: 30 }
  validates_format_of :password,
    with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/,
    if: :password_required?,
    message: "must include one number, one letter and be between 8 and 40 characters"

  accepts_nested_attributes_for :company, :leads, :preferred_hours

  before_create :build_availabilities
  before_save :check_for_blank_email
  before_save :convert_wage_to_cents

  attr_accessor :wage

  update_index "site_search#user", :self

  def as_json(_options={})
    super(only: [:email, :id, :given_name, :family_name, :preferred_name])
  end

  def hash_key
    super || generate_hash_key
  end

  def wage
    @wage || formatted_wage
  end

  def display_wage
    sprintf "%.2f", wage
  end

  def invitation_state
    if accepted_or_not_invited?
      if invitation_accepted_at.present? || sign_in_count > 0
        :active
      else
        :awaiting_invite
      end
    else
      :invited
    end

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
  end

  def build_availabilities
    PreferredHour.build_for(self)
  end

  def check_for_blank_email
    if self.email.blank?
      self.email = nil
    end
  end

  def generate_hash_key
    key = SecureRandom.hex(22)
    update_column(:hash_key, key)
    key
  end
end
