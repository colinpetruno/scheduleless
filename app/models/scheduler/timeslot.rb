module Scheduler
  class Timeslot

    attr_reader :x
    attr_reader :y
    attr_reader :employees

    def initialize(x, y, slots_available)
      @x = x
      @y = y
      @slots_available = slots_available
      @employees = []
    end

    def full
      @employees.length == @slots_available
    end

    def not_full?
      !full
    end

    def add_employee(employee)
      @employees.push(employee)
    end

    def print
      printf "[(#{@x},#{@y}) %{slots_available} %{employees} ]" % {slots_available: @slots_available,
                                                      employees: @employees.map { |e| e[:given_name]} }
    end

    def has_employee?(employee_id)
      @employees.any? {|e| e[:id] == employee_id}
    end
  end
end