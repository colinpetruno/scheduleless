module Blog
  module Admin
    class BaseController < AuthenticatedController
      layout "blog"

      skip_after_action :verify_authorized
      skip_after_action :verify_policy_scoped

      before_action :authorize_admin!

      private

      def authorize_admin!
        unless UserPermissions.for(current_user).scheduleless_admin?
          raise ActionController::RoutingError, "Not Found"
        end
      end
    end
  end
end
