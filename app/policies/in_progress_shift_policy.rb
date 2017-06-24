class InProgressShiftPolicy < ApplicationPolicy
  def destroy?
    true
  end

  def edit?
    true
  end

  def new?
    true
  end

  def update?
    true
  end
end
