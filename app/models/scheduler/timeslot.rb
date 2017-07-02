module Scheduler
  class Timeslot

    attr_reader :x
    attr_reader :y
    attr_reader :employees
    attr_reader :position_slots
    attr_reader :position_employees

    def initialize(x, y)
      @x = x
      @y = y
      @slots_available = 0
      @employees = []
      @position_slots = {}
      @position_employees = {}
    end

    def add_slots_available(amount, position)
      @slots_available = @slots_available + amount
      if @position_slots.key? position.name
        @position_slots[position.name] = @position_slots[position.name] + amount
      else
        @position_slots[position.name] = amount
        @position_employees[position.name] = []
      end
    end

    def full?
      @employees.length == @slots_available
    end

    def not_full?
      !full?
    end

    def positions
      position_slots.keys
    end

    def position_available?(employee)
      space_available = false
      employee.positions.each do |position|
        space_available = space_available || (position_exists?(position.name) && position_room_available?(position.name))
      end

      space_available = space_available || (position_exists?(employee.primary_position.name) && position_room_available?(employee.primary_position.name))

      space_available
    end

    def position_exists?(position_name)
      position_slots.key? position_name
    end

    def position_room_available?(position_name)
      if position_employees[position_name].nil?
        false
      else
        position_employees[position_name].length < position_slots[position_name]
      end
    end

    def add_employee(employee, position)
      @employees.push(employee)
      @position_employees[position].push(employee)
    end

    def employees
      @employees
    end

    def print
      printf "[(#{@x},#{@y}) %{slots_available} %{positions} %{employees} ]" % {slots_available: @slots_available,
                                                      employees: @employees.map { |e| e[:given_name] + " " + e[:family_name]},
                                                      positions: @position_slots}
    end

    def has_employee?(employee_id)
      @employees.any? {|e| e[:id] == employee_id}
    end
  end
end
