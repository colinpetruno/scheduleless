class User < ApplicationRecord
  belongs_to :company
  has_many :user_locations
  has_many :locations, through: :user_locations
  has_many :preferred_hours
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true

  accepts_nested_attributes_for :company

  before_create :build_availabilities

  private

  def build_availabilities
    PreferredHour.build_for(self)
  end
end
