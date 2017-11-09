module Coworkability
  class ReportsController < AuthenticatedController
    def new
      skip_authorization
      @hide_side_nav = true
      @report = Report.new
    end

    def create
      skip_authorization
      @hide_side_nav = true

      @report = Report.new(report_params)

      if @report.save
        redirect_to coworkability_report_path(@report)
      else
        render :new
      end
    end

    def show
      @hide_side_nav = true
      @report = Report.find(params[:id])
      authorize @report
    end

    private

    def report_params
      params.
        require(:report).
        permit(report_detail_attributes: [:summary]).
        merge(user_id: current_user.id,
              started_at: DateTime.now,
              completed: true)
    end
  end
end
