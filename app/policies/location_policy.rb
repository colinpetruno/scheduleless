class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.company_admin?
        user.company.locations
      else
        user.locations
      end
    end
  end

  def create?
    user.company_admin?
  end

  def edit?
    (user.company_admin? || user.location_admin?) && same_company?
  end

  def new?
    user.company_admin?
  end

  def show?
    same_company?
  end

  def update?
    (user.company_admin? || location_admin_for_record?) && same_company?
  end

  private

  # In order to avoid N+1 Queries on list views we are only checking to make
  # sure they are the location admin of the specific location when they try
  # to act upon a single record. Elsewhere in the UI they will not see
  # locations that do not belong to them so only checking if they can manage
  # their locations is good enough.
  def location_admin_for_record?
    user.location_admin? && user.locations.include?(record)
  end
end
