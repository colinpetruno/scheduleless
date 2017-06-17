module Remote
  class CalendarsController < AuthenticatedController
    def show
      authorize :calendar, :show?

      location = current_company.locations.find(params[:location_id])

      @presenter = CalendarPresenter.new(location: location, day: date)
    end

    private

    def date
      if params[:month].present? && params[:year].present?
        Date.parse("#{params[:year]}#{params[:month].rjust(2, "0")}01")
      else
        Date.today
      end
    end
  end
end
