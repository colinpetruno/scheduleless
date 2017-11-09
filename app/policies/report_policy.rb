class ReportPolicy < ApplicationPolicy
  def show?
    user.id == record.user_id
  end
end
