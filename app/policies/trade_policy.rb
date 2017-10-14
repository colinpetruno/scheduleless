class TradePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      base = scope.
        available.
        joins(:shift).
        includes(:offers)

      base.
        where(
          location_id: user.locations.pluck(:id),
          shifts: {
            date: ((location_date+1)..Float::INFINITY)
          }
        ).or(
          base.where(
            location_id: user.locations.pluck(:id),
            shifts: {
              date: location_date,
              minute_start: (location_time_minutes..Float::INFINITY)
            }
          )).
        where.not(user_id: user.id)
    end

    def location_date
      DateAndTime::LocationTime.
        new(location: user.locations.first).
        current_date_integer
    end

    def location_time_minutes
      DateAndTime::LocationTime.
        new(location: user.locations.first).
        current_time_minutes
    end
  end

  def create?
    Shifts::Finder.for(user).find_by(id: record.shift_id).present?
  end

  def new?
    true
  end
end
