module Calculators
  module Wages
    module Shifts
      module Processors
        class OvertimeAfterTwelve < Base
          def process
            {
              hours: hours,
              regular_hours: regular_hours,
              overtime_hours: overtime_hours,
              double_overtime_hours: 0,
              regular_hour_pay: regular_hour_cost,
              overtime_pay: overtime_hour_cost,
              double_overtime_pay: 0,
              total: overtime_hour_cost + regular_hour_cost
            }
          end

          private

          def overtime_hour_cost
            (overtime_hours) * normal_overtime_rate
          end

          def overtime_hours
            if hours > 12
              hours - 12
            else
              0
            end
          end

          def regular_hour_cost
            (regular_hours * rate)
          end

          def regular_hours
            if hours - 12 > 0
              12
            else
              hours
            end
          end
        end
      end
    end
  end
end
