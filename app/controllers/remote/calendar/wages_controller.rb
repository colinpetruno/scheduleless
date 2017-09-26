module Remote
  module Calendar
    class WagesController < AuthenticatedController
      def index
        @location = current_company.locations.find(params[:location_id])

        authorize :wage, :index?
        skip_policy_scope # we aren't using resolve here

        @wages = Calculators::Wages::WeeklyForLocation.new(location: @location)
      end
    end
  end
end
