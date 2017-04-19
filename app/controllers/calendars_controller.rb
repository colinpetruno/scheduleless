class CalendarsController < AuthenticatedController
  def show
    authorize :calendar, :show?

    @presenter = CalendarShowPresenter.new(user: current_user, date: date)
  end

  private

  def date
    Date.parse(params[:date]) || Date.today
  rescue
    Date.today
  end
end
