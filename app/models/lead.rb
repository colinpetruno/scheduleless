class Lead < ApplicationRecord
  belongs_to :user

  enum preferred_contact: {
    email: 0,
    phone: 1
  }

  validate :phone_presence?

  private

  def phone_presence?
    if phone? && self.user.mobile_phone.blank?
      errors.add(:preferred_contact, "must have a phone number")
    end
  end
end
