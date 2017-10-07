class TradePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.
        available.
        joins(:shift).
        includes(:offers).
        where(
          location_id: user.locations.pluck(:id),
          shifts: { date: (location_date..Float::INFINITY) }
        ).
        where.not(user_id: user.id)
    end

    def location_date
      DateAndTime::LocationTime.
        new(location: user.locations.first).
        current_date_integer
    end
  end

  def create?
    Shifts::Finder.for(user).find_by(id: record.shift_id).present?
  end

  def new?
    true
  end
end
