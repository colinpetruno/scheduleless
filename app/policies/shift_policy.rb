class ShiftPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      ShiftFinder.for(user).future.find
    end
  end
end
