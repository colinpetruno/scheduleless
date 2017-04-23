module Settings
  class PopularTimesController < AuthenticatedController
    def create
      authenticate PopularTime
    end

    def index
      policy_scope PopularTime
    end

    def new
      authenticate PopularTime
    end
  end
end
