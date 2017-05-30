class ReamazeOptions
  def self.for(user)
    new(user: user).as_hash
  end

  def initialize(user: nil)
    @user = user
  end

  def as_hash
    base_options.merge(user_options)
  end

  private

  attr_reader :user

  def base_options
    { brand_subdomain: "scheduleless" }
  end

  def user_options
    if user.present?
      {
        sso_key: Rails.application.secrets.reamaze,
        user_id: user.id,
        user_email: user.email,
        user: user
      }
    else
      {}
    end
  end
end
