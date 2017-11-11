module Admin
  class ReportsController < AdminController
    def index
      @my_reports = Report.claimed_by(current_user)
      @reports = Report.unclaimed
    end

    def show
      @report = Report.find(params[:id])
      @report.start(current_user)
    end
  end
end
