module Calculators
  module Wages
    module Shifts
      module Processors
        class OvertimeAfterEight < Base
          def process
            {
              hours: hours,
              regular_hours: regular_hours,
              overtime_hours: overtime_hours,
              double_overtime_hours: 0,
              regular_hour_pay: regular_hour_cost,
              overtime_pay: overtime_hour_cost,
              double_overtime_pay: 0,
              total: overtime_hour_cost + regular_hour_cost,
              rate: rate
            }
          end

          private

          def overtime_hour_cost
            (overtime_hours) * normal_overtime_rate
          end

          def overtime_hours
            if hours > 8
              hours - 8
            else
              0
            end
          end

          def regular_hour_cost
            (regular_hours * rate)
          end

          def regular_hours
            if hours - 8 > 0
              8
            else
              hours
            end
          end
        end
      end
    end
  end
end
