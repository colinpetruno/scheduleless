class User < ApplicationRecord
  belongs_to :company
  has_many :user_locations
  has_many :locations, through: :user_locations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true

  accepts_nested_attributes_for :company
end
