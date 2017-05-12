class TradePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.
        available.
        includes(:offers).
        where(
          location_id: user.locations.pluck(:id)
        ).
        where.not(user_id: user.id)
    end
  end

  def create?
    ShiftFinder.for(user).find_by(id: record.shift_id).present?
  end

  def new?
    true
  end
end
