class User < ApplicationRecord
  include NotDeletable

  belongs_to :company
  has_many :employee_positions
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

  validates :email, presence: true, length: { minimum: 3, maximum: 200 }
  validates :family_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :given_name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :mobile_phone, presence: true, length: { minimum: 7, maximum: 30 }

  accepts_nested_attributes_for :company, :preferred_hours

  before_create :build_availabilities

  update_index "site_search#user", :self

  def as_json(_options={})
    super(only: [:email, :id, :given_name, :family_name, :preferred_name])
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
