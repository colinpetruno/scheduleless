module Admin
  class IncidentsController < AdminController
    def new
      @report = Report.find(params[:report_id])
      @incident = @report.incidents.build
    end

    def edit
      @incident = Incident.find(params[:id])
      @report = @incident.report
    end

    def update
      @incident = Incident.find(params[:id])
      @report = @incident.report

      if @incident.update(incident_params)
        redirect_to admin_report_path(@report)
      else
        render :new
      end
    end

    def create
      @report = Report.find(params[:report_id])
      @incident = @report.incidents.build(incident_params)

      if @incident.save
        redirect_to admin_report_path(@report)
      else
        render :new
      end
    end

    private

    def incident_params
      params.
        require(:incident).
        permit(:likelihood, :rating, :user_id, :summary, :category)
    end
  end
end
