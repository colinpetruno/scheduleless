class Lead < ApplicationRecord
  attr_writer :mobile_phone

  belongs_to :user

  enum preferred_contact: {
    email: 0,
    phone: 1
  }

  validate :phone_presence?

  def mobile_phone
    @mobile_phone || self.user.mobile_phone || ""
  end

  private

  def phone_presence?
    if preferred_contact == "phone"
      if self.mobile_phone.blank?
        errors.add(:preferred_contact, "please provide a phone number below")
      else
        user.update_column(:mobile_phone, self.mobile_phone)
      end
    end
  end
end
