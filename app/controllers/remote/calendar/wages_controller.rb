module Remote
  module Calendar
    class WagesController < AuthenticatedController
      def index
        @location = current_company.locations.find(params[:location_id])
        @date = date

        authorize :wage, :index?
        skip_policy_scope # we aren't using resolve here

        @wages = Calculators::Wages::WeeklyForLocation.new(location: @location,
                                                           published: false,
                                                           date: @date)
      rescue Pundit::NotAuthorizedError
        render json: {}, status: :unauthorized
      end

      private

      def date
        Date.parse(params[:date])
      rescue
        Date.today
      end
    end
  end
end
