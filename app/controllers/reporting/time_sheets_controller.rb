module Reporting
  class TimeSheetsController < BaseController
    def show
      authorize [:reporting, :time_sheet], :show?
      location = current_company.locations.find(params[:location_id])

      @presenter = TimeSheetPresenter.new(company: current_company,
                                          date: Date.today,
                                          location: location)
    end
  end
end
