class CheckInPolicy < ApplicationPolicy
  def create?
    Shifts::Finder.for(user).find_by(id: record.shift_id).present?
  end
end
