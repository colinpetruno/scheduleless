class Lead < ApplicationRecord
  belongs_to :user

  enum preferred_contact: {
    email: 0,
    phone: 1
  }

  validate :phone_presence?

  private

  def phone_presence?
    if preferred_contact == "phone" && self.user.mobile_phone.blank?
      errors.add(:preferred_contact, "please provide a phone number below")
    end
  end
end
