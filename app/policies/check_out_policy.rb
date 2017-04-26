class CheckOutPolicy < ApplicationPolicy
  def create?
    ShiftFinder.for(user).find_by(id: record.shift.id).present?
  end
end
