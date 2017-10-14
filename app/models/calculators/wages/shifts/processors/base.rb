module Calculators
  module Wages
    module Shifts
      module Processors
        class Base
          def initialize(company: nil, shift:, location: nil, rate:)
            @company = company
            @shift = shift
            @location = location
            @rate = rate
          end

          def process
            {
              hours: hours,
              regular_hours: hours,
              overtime_hours: 0,
              double_overtime_hours: 0,
              regular_hour_pay: hours * rate,
              overtime_pay: 0,
              double_overtime_pay: 0,
              total: hours * rate,
              rate: rate
            }
          end

          def normal_overtime_rate
            # round up in pennies
            (rate * 1.5).ceil
          end

          def double_overtime_rate
            (rate * 2)
          end

          def hours
            DateAndTime::ShiftDateTime.for(shift, location).length_in_hours
          end

          private

          attr_reader :shift, :rate

          def company
            @company ||= shift.company
          end

          def location
            @location ||= shift.location
          end
        end
      end
    end
  end
end
