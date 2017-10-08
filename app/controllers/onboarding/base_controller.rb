module Onboarding
  class BaseController < AuthenticatedController
    skip_before_action :needs_onboarding?
  end
end
