class CalendarPolicy < ApplicationPolicy
  def show?
    # TODO add in location checking
    true
  end
end
