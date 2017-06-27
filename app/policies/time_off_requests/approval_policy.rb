module TimeOffRequests
  class ApprovalPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        pending_time_off = PendingTimeOffRequests.new(user: user)

        if pending_time_off.approve?
          pending_time_off.waiting_approval
        else
          []
        end
      end
    end

    def create?
      UserPermissions.for(user).manage?(record.user)
    end
  end
end
