class DashboardsController < AuthenticatedController
  def show
    authorize :dashboard, :show?
  end
end
