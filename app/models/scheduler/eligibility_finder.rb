module Scheduler
  class EligibilityFinder
    def initialize(layout:, timeslot:)
      @layout = layout
      @timeslot = timeslot
    end

    def find
      adjacent_employees.push(up_slot.employees) if up_slot
      adjacent_employees.push(right_slot.employees) if right_slot
      adjacent_employees.push(down_slot.employees) if down_slot
      adjacent_employees.push(left_slot.employees) if left_slot

      adjacent_employees.flatten!.uniq!

      timeslot.employees.each do |employee|
        adjacent_employees.delete(employee)
      end

      adjacent_employees
    end

    private

    attr_reader :layout, :timeslot

    def get_timeslot(x, y)
      layout.get_timeslot(x, y)
    end

    def adjacent_employees
      @_adjacent_employees ||= []
    end

    def up_slot
      get_timeslot(timeslot.x, timeslot.y - 1)
    end

    def down_slot
      get_timeslot(timeslot.x, timeslot.y + 1)
    end

    def right_slot
      get_timeslot(timeslot.x + 1, timeslot.y)
    end

    def left_slot
      get_timeslot(timeslot.x - 1, timeslot.y)
    end
  end
end
