class CheckInPolicy < ApplicationPolicy
  def create?
    ShiftFinder.for(user).find_by(id: record.shift_id).present?
  end
end
