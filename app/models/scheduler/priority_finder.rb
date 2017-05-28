module Scheduler
  class PriorityFinder

    attr_reader :options

    def initialize(options:)
      @options = options
    end

    def highest_priority_employee(eligible_employees, position, timeslot, layout)
      weighted_parameters = options.weighted_parameters

      # Vertical Weights
      v_weight_value = weighted_parameters[:vertical_adjacency]
      vertical_weight = weigh_vertical_adjacency(eligible_employees, position, timeslot, layout, v_weight_value)

      # Horizontal Weights
      h_weight_value = weighted_parameters[:horizontal_adjacency]
      horizontal_weight = weigh_horizontal_adjacency(eligible_employees, position, timeslot, layout, h_weight_value)

      # Preferred Hours
      preferred_hours_weight = weighted_parameters[:preferred_timeslot]
      preferred_weight = weigh_preferred_hours(eligible_employees, timeslot, preferred_hours_weight)

      puts preferred_weight

      # Merge and Add
      # Vertical + Horizontal
      combined_weights = sum_merge_hash(sum_merge_hash(vertical_weight, horizontal_weight), preferred_weight)

      highest_priority_score = -1
      highest_employee_id = eligible_employees[0]["id"]

      combined_weights.each do |key, value|

        if value > highest_priority_score and eligible_employees.any?{|e| e["id"] == key}
          highest_priority_score = value
          highest_employee_id = key
        end
      end

      eligible_employees.detect {|employee| employee["id"] == highest_employee_id }
    end

    private

    def weigh_vertical_adjacency(eligible_employees, position, timeslot, layout, weight)
      weights = {}

      up_slot = get_timeslot(layout, timeslot.x, timeslot.y - 1)
      down_slot = get_timeslot(layout, timeslot.x, timeslot.y + 1)

      vertical_adjacent_employees.push(up_slot.position_employees[position]) if up_slot
      vertical_adjacent_employees.push(down_slot.position_employees[position]) if down_slot

      vertical_adjacent_employees.flatten!
      vertical_adjacent_employees.compact!

      eligible_employees.each do |employee|
        count = 0
        vertical_adjacent_employees.each do |v_employee|
          if v_employee.id == employee.id
            count = count + 1
          end
        end

        weights[employee.id] = count * weight
      end

      weights
    end

    def weigh_horizontal_adjacency(eligible_employees, position, timeslot, layout, weight)
      weights = {}

      left_slot = get_timeslot(layout, timeslot.x-1, timeslot.y)
      right_slot = get_timeslot(layout, timeslot.x+1, timeslot.y)

      horizontal_adjacent_employees.push(left_slot.position_employees[position]) if left_slot
      horizontal_adjacent_employees.push(right_slot.position_employees[position]) if right_slot

      horizontal_adjacent_employees.flatten!
      horizontal_adjacent_employees.compact!

      eligible_employees.each do |employee|
        count = 0
        horizontal_adjacent_employees.each do |v_employee|
          if v_employee.id == employee.id
            count = count + 1
          end
        end

        weights[employee.id] = count * weight
      end

      weights
    end

    def weigh_preferred_hours(eligible_employees, timeslot, weight)
      weights = {}

      eligible_employees.each do |employee|
        if timeslot_in_preferred_hours(employee, timeslot)
          weights[employee.id] = weight
        else
          weights[employee.id] = 0
        end
      end

      weights
    end

    def sum_merge_hash(h1, h2)
      h1.merge(h2){|k, v1, v2| v1 + v2}
    end

    def vertical_adjacent_employees
      @_vertical_adjacent_employees ||= []
    end

    def horizontal_adjacent_employees
      @_horizontal_adjacent_employees ||= []
    end

    def get_timeslot(layout, x, y)
      layout.get_timeslot(x, y)
    end

    def timeslot_in_preferred_hours(employee, timeslot)
      PreferredHoursHelper.new(employee: employee, timeslot: timeslot, options: options).timeslot_in_preferred_hours
    end
  end
end