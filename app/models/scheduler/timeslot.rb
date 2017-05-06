module Scheduler
  class Timeslot

    attr_reader :x
    attr_reader :y
    attr_reader :employees
    attr_reader :position_slots
    attr_reader :position_employees
    attr_reader :options

    def initialize(x, y, slots_available, rules, options)
      @x = x
      @y = y
      @slots_available = slots_available
      @employees = []
      @position_slots = {}
      @position_employees = {}
      @options = options

      read_rule_slots(rules)
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

    def add_employee(employee, position=nil)
      @employees.push(employee)
      @position_employees[position].push(employee) if not position.nil?
    end

    def read_rule_slots(rules)
      rules.each do |rule|
        if rule_within_bounds(rule.period, y)
          if position_slots.key? rule.position.name
            position_slots[rule.position.name] = position_slots[rule.position.name] + 1
          else
            position_slots[rule.position.name] = 1
            position_employees[rule.position.name] = []
          end
        end
      end
    end

    def rule_within_bounds(rule_period, interval)
      interval_minutes = interval*options.time_interval_minutes
      rule_timeframe = options.period_timeframes(rule_period)
      interval_minutes >= rule_timeframe[:start] && interval_minutes < rule_timeframe[:end]
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