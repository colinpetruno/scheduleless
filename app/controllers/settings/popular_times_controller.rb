module Settings
  class PopularTimesController < AuthenticatedController
    def index
      @popular_times = policy_scope PopularTime
    end

    def new
      authorize PopularTime
    end
  end
end
