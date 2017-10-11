module Users
  class Emailable
    DOMAIN_BLACKLIST = %w(example.com)

    def self.for(user)
      new(user: user).emailable?
    end

    def initialize(user:)
      @user = user
    end

    def emailable?
      email_present? && email_domain_valid?
    end

    private

    attr_reader :user

    def email_present?
      user.email.present?
    rescue
      false
    end

    def email_domain_valid?
      DOMAIN_BLACKLIST.exclude?(user.email.split("@").last)
    rescue StandardError => error
      Bugsnag.notify(error)

      false
    end
  end
end
