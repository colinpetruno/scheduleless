module Dashboard
  class BasePresenter
    attr_reader :company, :user

    def initialize(user, company)
      @user = user
      @company = company
    end
  end
end
