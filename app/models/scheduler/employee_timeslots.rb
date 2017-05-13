module Scheduler
  class EmployeeTimeslots
    def initialize
      @employees = {}
    end

    def count_for(employee)
      # TODO: Chris, this was erroring out, im rescuing as a 0 for now, see if
      # this works
      employees[employee.id].length
    rescue
      0
    end

    def for(employee)
      employees[employee.id] || []
    end

    def add_for(employee:, day:, slot_number:)
      get_or_initialize_for(employee).push([day, slot_number])
    end

    private

    attr_reader :employees

    def get_or_initialize_for(employee)
      if employees[employee.id].blank?
        employees[employee.id] = []
      end

      employees[employee.id]
    end
  end
end
