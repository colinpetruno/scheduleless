module Reporting
  class TimeSheetPolicy < ApplicationPolicy
    def show?
      true
    end
  end
end
