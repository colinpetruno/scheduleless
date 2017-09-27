module Remote
  module Calendar
    class CalendarSidebarsController < AuthenticatedController
      def show
        skip_authorization

        @location = current_company.locations.find(params[:location_id])

        @presenter = CalendarPresenter.
          new(day: params[:date],
              location: @location,
              month: params[:month],
              schedule_start: current_company.schedule_start)
      end
    end
  end
end
