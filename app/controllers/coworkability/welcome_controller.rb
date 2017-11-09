module Coworkability
  class WelcomeController < AuthenticatedController
    def index
      skip_policy_scope
      @hide_side_nav = true

      authorize :coworkability, :edit?
    end
  end
end
