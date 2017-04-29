class CancellationPolicy < ApplicationPolicy
  def create?
    record.shift.belongs_to?(user)
  end
end
