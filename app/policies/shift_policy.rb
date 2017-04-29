class ShiftPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      ShiftFinder.for(user).future
    end
  end
end
