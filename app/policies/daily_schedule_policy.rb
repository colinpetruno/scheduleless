class DailySchedulePolicy < ApplicationPolicy
  def show?
    user.locations.include?(record.location)
  end
end
