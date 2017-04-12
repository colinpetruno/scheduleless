class CalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?
  end
end
