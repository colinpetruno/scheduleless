class TimeOffRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      TimeOffRequestFinder.for(user).locate
    end
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    true
  end
end
