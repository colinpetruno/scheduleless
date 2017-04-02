module Scheduler
  class EligibilityFinder
    def self.for(timeslot, schedule)
      new(schedule: schedule, timeslot: timeslot)
    end

    def initialize(schedule:, timeslot:)
      @schedule = schedule
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

    attr_reader :schedule, :timeslot

    def adjacent_employees
      @_adjacent_employees ||= []
    end

    def up_slot
      schedule.timeslot(timeslot.x, timeslot.y - 1)
    end

    def down_slot
      schedule.timeslot(timeslot.x, timeslot.y + 1)
    end

    def right_slot
      schedule.timeslot(timeslot.x + 1, timeslot.y)
    end

    def left_slot
      schedule.timeslot(timeslot.x - 1, timeslot.y)
    end
  end
end
