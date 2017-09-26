module Calculators
  module Wages
    module Shifts
      module Processors
        class VirginIslands < Base
          def process
            {
              hours: hours,
              regular_hours: regular_hours,
              overtime_hours: overtime_hours,
              double_overtime_hours: 0,
              regular_hour_pay: regular_hour_cost,
              overtime_pay: overtime_hour_cost,
              double_overtime_pay: 0,
              total: total_cost
            }
          end

          private

          def company
            shift.company
          end

          def schedule_period
            @_schedule_period ||= SchedulePeriod.for(company)
          end

          def cycle_day
            schedule_period.day_of(shift.date)
          end

          def days_worked
            @_days_worked ||= ConsecutiveDaysWorked.for(shift)
          end

          def consecutive?
            days_worked >= cycle_day
          end

          def total_cost
            overtime_hour_cost + regular_hour_cost
          end

          def overtime_hour_cost
            (overtime_hours * normal_overtime_rate)
          end

          def overtime_hours
            if cycle_day >= 6 && consecutive?
              # overtime on sixth or seventh day
              hours
            else
              # normal day
              if hours > 8
                if hours > 12
                  4
                else
                  hours - 8
                end
              else
                0
              end
            end
          end

          def regular_hour_cost
            (regular_hours * rate)
          end

          def regular_hours
            if cycle_day >= 6 && consecutive?
              0
            else
              if (hours - 8) > 0
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
end
