class CheckOutPolicy < ApplicationPolicy
  def create?
    Shifts::Finder.for(user).find_by(id: record.shift.id).present?
  end
end
