module Blog
  class AdminPolicy < ApplicationPolicy
    def show?
      if user.present?
        UserPermissions.for(user).scheduleless_admin?
      else
        false
      end
    end
  end
end
