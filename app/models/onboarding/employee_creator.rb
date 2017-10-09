module Onboarding
  class EmployeeCreator
    include ActiveModel::Model

    validates :family_name, presence: true, length: { minimum: 1, maximum: 200 }
    validates :given_name, presence: true, length: { minimum: 1, maximum: 200 }
    validates :primary_position_id, presence: true
    validate :email_unique

    attr_accessor :company, :email, :family_name, :given_name, :locations,
      :mobile_phone, :preferred_name, :primary_position_id, :position_ids,
      :salary, :wage_cents, :wage

    def create
      user = User.new(user_params)
      user.save(validate: false)
    end

    def model_name
      ActiveModel::Name.new(User)
    end

    private

    def email_unique
      if User.where(email: email).exists?
        errors.add(:email, "is already taken")
      end
    end

    def user_params
      {
        company: company,
        email: email,
        family_name: family_name,
        given_name: given_name,
        locations: locations,
        mobile_phone: mobile_phone,
        preferred_name: preferred_name,
        primary_position_id: primary_position_id,
        position_ids: position_ids,
        salary: salary,
        wage: wage
      }
    end
  end
end
