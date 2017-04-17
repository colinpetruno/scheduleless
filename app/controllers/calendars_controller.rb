class CalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?

    @presenter = CalendarShowPresenter.new(user: current_user)
  end
end
