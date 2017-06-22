class User < ApplicationRecord
  include NotDeletable

  belongs_to :company
  belongs_to :primary_position, class_name: "Position"

  has_many :firebase_tokens
  has_many :employee_positions
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

  validates :email, presence: true, length: { minimum: 3, maximum: 200 }, uniqueness: true
  validates :family_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :given_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :mobile_phone, presence: true, length: { minimum: 7, maximum: 30 }
  validates_format_of :password,
    with: /\A(?=.\d)(?=.([a-z]|[A-Z]))([\x20-\x7E]){8,40}\z/,
    if: :require_password?,
    message: "must include one number, one letter and be between 8 and 40 characters"

  accepts_nested_attributes_for :company, :leads, :preferred_hours

  before_create :build_availabilities

  update_index "site_search#user", :self

  def as_json(_options={})
    super(only: [:email, :id, :given_name, :family_name, :preferred_name])
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
    positions.where(location_admin: true).present? && locations.include?(location)
  end

  def company_admin?
    super || positions.where(company_admin: true).present?
  end

  def deliver_invitation(options = {})
    super # send email through devise invitable
    # send twilio
  end

  def location_admin?
    positions.where(location_admin: true).present?
  end

  def twilio_formatted_phone
  end

  private

  def build_availabilities
    PreferredHour.build_for(self)
  end
end
