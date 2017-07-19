class NewCalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?
  end
end
