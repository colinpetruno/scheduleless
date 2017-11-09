module Coworkability
  module Reports
    class WelcomeController < AuthenticatedController
      def index
        skip_policy_scope
        @hide_side_nav = true
      end
    end
  end
end
