module Admin
  class PlansController < AdminController
    def create
      @plan = Plan.new(plan_params)

      if @plan.save
        redirect_to admin_plans_path
      else
        render :new
      end
    end

    def edit
      @plan = Plan.find(params[:id])
    end

    def index
      @plans = Plan.all.order(:plan_name)
    end

    def new
      @plan = Plan.new
    end

    def update
      @plan = Plan.find(params[:id])

      if @plan.update(plan_params)
        redirect_to admin_plans_path
      else
        render :edit
      end
    end

    private

    def plan_params
      params.require(:plan).permit(:default, :plan_name, feature_ids: [])
    end
  end
end
