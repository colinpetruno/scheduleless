module Blog
  class AdminPolicy < ApplicationPolicy
    def show?
      UserPermissions.for(user).scheduleless_admin?
    end
  end
end
