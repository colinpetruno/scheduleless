class LoginUser < ApplicationRecord
  include EmailValidatable
  include NotDeletable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :user

  accepts_nested_attributes_for :user

  validates :email,
            email: true,
            length: { minimum: 3, maximum: 200 },
            uniqueness: true

  validates_format_of :password,
    with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/,
    if: :password_required?,
    message: "must include one number, one letter and be between 8 and 40 characters"
end
