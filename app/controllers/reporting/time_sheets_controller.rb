module Reporting
  class TimeSheetsController < BaseController
    def show
      authorize [:reporting, :time_sheet], :show?
      locations = policy_scope(Location)
      location = locations.find(params[:location_id])

      @presenter = TimeSheetPresenter.new(company: current_company,
                                          date: date,
                                          locations: locations,
                                          location: location)
    end

    private

    def date
      Date.parse(params[:date])
    rescue
      Date.today
    end
  end
end
