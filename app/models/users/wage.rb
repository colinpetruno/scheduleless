module Users
  class Wage
    def self.for(user:, company: nil, position: nil)
      new(user: user, company: company, position: position).rate
    end

    def initialize(user: nil, company: nil, position: nil)
      @company = company
      @position = position
      @user = user
    end

    def rate
      if company.pay_by_type == "user"
        user.wage_cents || position_base_pay
      else
        position_base_pay
      end
    end

    private

    attr_reader :user, :position

    def company
      @company ||= user.company
    end

    def position_base_pay
      return 0 if position.blank?

      position.base_pay
    end
  end
end
