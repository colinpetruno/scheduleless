module Admin
  class ApprovalsController < AdminController
    def create
      @scheduling_period = SchedulingPeriod.find(params[:scheduling_period_id])

      if @scheduling_period.update(status: :scheduleless_approved)
        redirect_to admin_schedule_approvals_path
      else
        redirect_to admin_scheduling_period_path(@scheduling_period),
          alert: "Something Went Wrong"
      end
    end
  end
end
