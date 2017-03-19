module Business
  class UsersController < AuthenticatedController
    def index
      @users = current_company.users
    end
  end
end
