class DashboardsController < AuthenticatedController
  def show
    # TODO: add locations a person is at here
    authorize :dashboard, :show?
  end
end
