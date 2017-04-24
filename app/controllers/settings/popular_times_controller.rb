module Settings
  class PopularTimesController < AuthenticatedController
    def index
      policy_scope PopularTime
    end

    def new
      authorize PopularTime
    end
  end
end
